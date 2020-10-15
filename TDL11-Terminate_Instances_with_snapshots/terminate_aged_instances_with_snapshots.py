#!/usr/local/bin/env python3.8
#
# How to use:
# ./terminate_aged_instances.py [current_time]
# current_time: YYYYMMDDHHmm, default value: current time
import boto3
import sys
import json
import logging
import datetime
import botocore
from botocore.exceptions import ClientError

# Import pytz to support local timezone
import pytz

# logging
if len(logging.getLogger().handlers) <= 0:
    logging.basicConfig()
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Default values
region_name = 'ap-southeast-2'
default_time_zone = 'Australia/Melbourne'
current_time = 'none'
tag_key='AgedTime'


ec2 = boto3.client("ec2")
resource = boto3.resource('ec2', region_name = region_name)

# check current_time is provided from command line, and format is correct
def validate_datetime_format(date_text,date_formate,date_input_format):
    try:
        datetime.datetime.strptime(date_text,date_formate)
    except ValueError:
        raise ValueError("Incorrect data format, should be "+date_input_format)

# Check EC2 instances in your accouunt which has tag AgedTime and AgedTime <= current_time
def get_instances_by_tag(tag_key,current_time):
    response = ec2.describe_instances(
        Filters=[
            {
                'Name': 'tag:'+tag_key,
                'Values': [
                    '*'
                ]
            } 
        ]
    )
    instanceIds = []
    instances = []
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            InstanceId = (instance['InstanceId'])
            ec2instance = resource.Instance(InstanceId)
            for tags in ec2instance.tags:
                if tags["Key"] == tag_key:
                    agedtimeValue = tags["Value"]
                    print(f'agedtime:{agedtimeValue}')
                    if agedtimeValue <= current_time: 
                        print('agedtimeValue <= current_time')
                        instanceIds.append(instance["InstanceId"])
                        instances.append(instance)
    print(json.dumps(instanceIds, indent=5))
    #print(instanceIds, sep = "\n") 
    # pprint.pprint(instanceIds)
    return instances

def shutdown_instance(instance_id):
    print(f"Instance is running, shutting down prior to creating snapshot(s) of attached volume(s)")
    # Do a dryrun first to verify permissions
    try:
        ec2.stop_instances(InstanceIds=[instance_id], DryRun=True)
    except ClientError as e:
        if 'DryRunOperation' not in str(e):
            raise e
    # Dry run succeeded, call stop_instances without dryrun
    try:
        response = ec2.stop_instances(InstanceIds=[instance_id], DryRun=False)
        logger.info("Stopping instance %s.", instance_id)
        print(response)
    except ClientError as e:
        logger.exception("Couldn't stop instance %s.", instance_id)
        raise e
    print(f"Waiting for Instance {instance_id} to be shutdown")
    # shutdown_instance_wait(instance_id)

# def shutdown_instance_wait(instance_id):
#     shutdown_instance_waiter = ec2.get_waiter('instance_stopped')
#     try:
#         shutdown_instance_waiter.wait(InstanceIds=[instance_id])
#         print(f"Instance {instance_id} has shutdown successfully")
#     except botocore.exceptions.WaiterError as e:
#         print(e)

def snapshots_wait(snapshot_ids):
    try:
        create_snapshot_waiter = ec2.get_waiter('snapshot_completed')
        print(f"Waiting for {snapshot_ids}")
        create_snapshot_waiter.wait(SnapshotIds=snapshot_ids) 
        print(f"snapshot {snapshot_ids} has created successfully") 
    except botocore.exceptions.WaiterError as e:
        print(e)

def check_ebs(instance_id,intances):
    print(f"Checking volumes attached to {instance_id} for Termination settings")
    logger.info(f"Checking volumes attached to {instance_id} for Termination settings")
    for block_device in intances.get('BlockDeviceMappings'):
        device_type = block_device.get('Ebs', None) 
        if device_type is None:
            continue
        device_name = block_device.get('DeviceName') 
        delete_on_termination = device_type.get('DeleteOnTermination')
        if delete_on_termination == False:
            print(f"EBS {device_name} is not set to delete on termination, set it true")
            response = ec2.modify_instance_attribute(
                Attribute='blockDeviceMapping',
                BlockDeviceMappings=[
                    {
                        'DeviceName': device_name,
                        'Ebs': {
                            'DeleteOnTermination': True,
                            }
                    }
                ],
                InstanceId=instance_id)
            print(response)
        else:
            print(f"Instance{instance_id}- EBS {device_name} had been set DeleteOnTermination true.")

def snapshot_volumes(instance_id,intances):
    snapshot_ids=[]
    print(f"Processing volumes attached to {instance_id} for snapshots")
    # Do a dryrun first to verify permissions
    try:
        response = ec2.create_snapshots(
            Description='snapshot_'+instance_id,
            InstanceSpecification={
                'InstanceId': instance_id,
                'ExcludeBootVolume': True
            },
            DryRun=True,
            CopyTagsFromSource='volume'
        )
    except ClientError as e:
        if 'DryRunOperation' not in str(e):
            raise e
    # Dry run succeeded, call creare snapshots without dryrun
    try:
        logger.info("create snapshots for instance %s.", instance_id)
        response = ec2.create_snapshots(
            Description='snapshot_'+instance_id,
            InstanceSpecification={
                'InstanceId': instance_id,
                'ExcludeBootVolume': True
            },
            DryRun=False,
            CopyTagsFromSource='volume'
        )
        print(response)
        # Check if snapshots are created completely.
        for snapid in response.get('Snapshots'):
            print(snapid.get('SnapshotId'))
            snapshot_ids.append(snapid.get('SnapshotId'))
            snapshots_wait(snapshot_ids)
    except ClientError as e:
        logger.exception("Couldn't create snapshots %s.", instance_id)
        raise e
    
def terminate_instances(instance_id):
    print(f"Proceding with termination of {instance_id}")
    # Do a dryrun first to verify permissions
    try:
        ec2.terminate_instances(InstanceIds=[instance_id], DryRun=True)
    except ClientError as e:
        if 'DryRunOperation' not in str(e):
            raise e
    # Dry run succeeded, call terminate_instances without dryrun
    try:
        logger.info("Terminating instance %s.", instance_id)
        response = ec2.terminate_instances(InstanceIds=[instance_id], DryRun=False)
        print(response)
    except ClientError as e:
        logger.exception("Couldn't terminate instance %s.", instance_id)
        print(e)
        raise e

def main():
    input_number=len(sys.argv)
    if input_number == 1:
        tz = pytz.timezone(default_time_zone)   
        current_time = datetime.datetime.now(tz).strftime('%Y%m%d%H%M') # if not provided, set current_time to default_current_time
    elif input_number == 2:
        validate_datetime_format(sys.argv[1],'%Y%m%d%H%M','YYYYMMDDHHmm')
        current_time = sys.argv[1]
        print("has input")
    else:
        print('Input error, please only input current time or input nothing.')
    print(f'current_time:{current_time}')
    instances = get_instances_by_tag(tag_key,current_time)
    for instance in instances:
        instance_id=instance.get('InstanceId')
        instance_state=instance['State']['Name']
        print(f"The instance {instance_id} state is {instance_state}.")
        if instance_state=='terminated' or instance_state=='pending' or instance_state=='running' or instance_state=='shutting-down':
            continue
        elif instance_state=='running':
            print(f"The instance {instance_id} state is {instance_state}, will be shutdown first.")
            shutdown_instance(instance_id)
        elif instance_state=='stopped':
            check_ebs(instance_id,instance)
            print(f"The instance {instance_id} state is {instance_state}, will be teminated.")
            snapshot_volumes(instance_id,instance)
            terminate_instances(instance_id)
        else:
             print(f"Warning : the instance {instance_id} state is not valid, please check it")

# Local version
if  __name__ =='__main__':
    main()
