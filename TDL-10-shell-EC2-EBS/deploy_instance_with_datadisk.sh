#!/bin/bash
#
# Deploy  AWS instance with different ostype, intance type, datadisk size and add tages like agedtime.
# Data disk: mount point /data
# Author: Yvonne Yao

# set variables
ostype=$1
agedtime=$2
data_disk_size=$3
instance_type=${4:-t2.micro}  # default value 

export AWS_DEFAULT_REGION='ap-southeast-2'
DEFAULT_TIME_ZONE='Australia/Melbourne'
declare -a LIST_OSTYPE
LIST_OSTYPE=('amzn' 'amzn2' 'centos6' 'centos7' 'ubuntu')
declare -a LIST_INSTANCE_TYPE
LIST_INSTANCE_TYPE=('t2.micro' 't2.small' 't3.micro')

KEY_NAME='da-key'
VPC_NAME='da-c02-vpc'
EC2_NAME="${1}_test6"
RULE=';1900;;all'
DEVICE_NAME='/dev/sdf'
PRIVATE_SUBNET_A_NAME='da-c02-private-a'
SG_PRIVATE_NAME='da-c02-private-sg'

VPC_ID=$(aws ec2 describe-vpcs \
    --filter "Name=tag:Name,Values=$VPC_NAME" \
    --query Vpcs[].VpcId --output text)
echo $VPC_ID

PRIVATE_SUBNET_A_ID=$(aws ec2 describe-subnets  \
    --filter "Name=tag:Name,Values=$PRIVATE_SUBNET_A_NAME" \
    --query 'Subnets[].SubnetId' --output text)
echo "${PRIVATE_SUBNET_A_ID}"

SG_PRIVATE_ID=$(aws ec2 describe-security-groups \
    --filters Name=vpc-id,Values="${VPC_ID}" Name=group-name,Values="${SG_PRIVATE_NAME}" \
    --query  'SecurityGroups[*].[GroupId]'  --output text)
echo "${SG_PRIVATE_ID}"

# start_time=$(date -d "$(TZ='Australia/Melbourne' date)" +%Y%m%d%H%M%S)
# echo ${start_time}
## AgedTime: yyyymmddhhmm (current time + agedtime days in Australia/Melbourne Time)
stop_time=$(date -d "$(TZ=$DEFAULT_TIME_ZONE date) $agedtime days" +%Y%m%d%H%M) #-3600s
# stop_time=$(date -d "$(TZ=$DEFAULT_TIME_ZONE date) $agedtime days 0 seconds" +%Y%m%d%H%M%S) #-3600s
echo ${stop_time}

#######################################
# Print a message in a given color.
# Arguments:
#   Color. eg: green, red
#######################################
function print_color(){
  NC='\033[0m' # No Color
  case $1 in
    "green") COLOR='\033[0;32m' ;;
    "red") COLOR='\033[0;31m' ;;
    "*") COLOR='\033[0m' ;;
  esac
  echo -e "${COLOR} $2 ${NC}"
}

#######################################
# Check item in a list.
# Arguments:
#   list item
#######################################
function list_include_item {
  list="$1"
  item="$2"
  if [[ $list =~ (^|[[:space:]])"$item"($|[[:space:]]) ]] ; then
    result=0  # yes, list include item
  else
    result=1
  fi
  echo $result
  return $result
}

#######################################
# Show how to use the deploy_instance.sh.
# Arguments:
#   None
#######################################
function usage(){
  print_color "green" "To deploy your instance, please run deploy_instance.sh as follows:"
  print_color "green" "./deploy_instance.sh ostype agedtime data_disk_size [instance_type]"
  print_color "green" "The value range of the arguments: "
  print_color "green" "1. valid ostype: amzn, amzn2, centos6, centos7, ubuntu"
  print_color "green" "2. agedtime: 1-7 "
  print_color "green" "3. data_disk_size: 5-100 (GB)"
  print_color "green" "4. instance_type: default t2_micro, valid instance_type: t2.micro, t2.small, t3.micro"
}

# check input
print_color "green" "-----------------------------Your input:-------------------------------"
echo "ostype=$1,agetime=$2,data_disk_size=$3,instance_type=$4"
print_color "green" "-----------------------------Check input-------------------------------"

# if less than 2 parameters from command line, print usage() and exit
if [[ $# -lt 3 || $# -gt 4 ]];  then
  usage
  print_color "red" "Input number error.Please input no less than 2 parameters."
  exit
fi

# check whehter ostype is a valid option, if ostype is an invalid ostype, print usage() and exit 
list_include_item "${LIST_OSTYPE[*]}" "$ostype"
result=$?
if (( result == 1 )); then
  print_color "red" "Ostype input error. Please input valid ostype: amzn, amzn2, centos6, centos7, ubuntu"
  usage
  exit
fi

# check whether 1 <= agedtime <=7, otherwise iprint usage() and exit
re='^[0-9]+$'
if ! [[ $agedtime =~ $re ]] ; then
   print_color "red" "Input agedtime error: Not a number"
   usage
   exit
fi

if (( agedtime < 1 || agedtime > 7 )); then
  print_color "red" "Input agedtime error. Please input valid agedtime: 1-7"
  usage
  exit
fi

# check whether 5 <= data_disk_size <=100, otherwise iprint usage() and exit
if ! [[ $data_disk_size =~ $re ]] ; then
   print_color "red" "Input data_disk_size error: Not a number"
   usage
   exit
fi

if (( data_disk_size < 5 || data_disk_size > 100 )); then
  print_color "red" "Input data_disk_size error. Please input valid data_disk_size: 5-100"
  usage
  exit
fi

# check whether instance_type is valid, otherwise iprint usage() and exit
if [[ $# -eq 4 ]];  then
  list_include_item "${LIST_INSTANCE_TYPE[*]}" "$4"
  result=$?
  if (( result == 1 )); then
    print_color "red" "Input instance type error.Please input valid instance_type: t2.micro, t2.small, t3.micro"
    usage
    exit
  fi
fi
echo "input correct"

# Find the latest image id for ostype and print out the image_id, image_name
print_color "green" "------------------Find the latest image id for ostype -----------------"
case "$ostype" in
  amzn)
    image_id=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-gp2 \
    --query 'Parameters[0].[Value]' --output text)
    # image_id=$(aws ec2 describe-images  --owners 'amazon'  --filters 'Name=description,Values=Amazon Linux AMI*' \
    # --query 'sort_by(Images, &CreationDate)[-1].[ImageId]'  --output 'text')
    ;;
  amzn2)
    image_id=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
      --query 'Parameters[0].[Value]' --output text)
    ;;
  centos6)
    image_id=$(aws ec2 describe-images --owners 679593333241 \
      --filters \
        Name=name,Values='CentOS Linux 6 x86_64 HVM EBS*' \
        Name=architecture,Values=x86_64 \
        Name=root-device-type,Values=ebs \
      --query 'sort_by(Images, &Name)[-1].ImageId' \
      --output text)
    ;;
  centos7)
    image_id=$(aws ec2 describe-images --owners aws-marketplace \
      --filters \
        Name=name,Values='CentOS Linux 7 x86_64 HVM*' \
        Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce \
        Name=architecture,Values=x86_64 \
        Name=root-device-type,Values=ebs \
      --query 'sort_by(Images, &CreationDate)[-1].[ImageId]' \
      --output text)
    ;;
  ubuntu)
    image_id=$(aws ec2 describe-images \
      --owners 099720109477 \
      --filters Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-* \
      --query 'sort_by(Images,&CreationDate)[-1].ImageId' --output text)
    ;;
esac
echo "Find the latest image of $ostype: ${image_id}"
 
#  Create EC2 instance for osype with instance_type with below settings:
print_color "green" "-------------------------Create EC2 instance---------------------------"
# Create user_data file
cat << EOF > ./instance_userdata.txt
#!/bin/bash
cat <<EOT >> /etc/motd
"OSType: ${ostype}"
"Please be notified that your instance will be terminated by  ${stop_time}"
EOT
cp /etc/fstab /etc/fstab.orig
if [ "\$(file -b -s /dev/xvdf)" == "data" ]; then
  mkfs -t ext4 /dev/xvdf
fi
mkfs -t ext4 /dev/xvdf
mkdir -p /data
mount /dev/xvdf /data
echo '/dev/xvdf /data ext4 defaults,nofail 0 2' >> /etc/fstab
sudo umount /data
sudo mount -a
EOF

# Create device mapping.json file
cat << EOF > ./mapping.json
[
    {
        "DeviceName": "${DEVICE_NAME}",
        "Ebs": {
            "VolumeSize": ${data_disk_size}
        }
    }
]
EOF

# Create instance
instance_id=$(aws ec2 run-instances \
  --image-id "$image_id" \
  --instance-type "$instance_type" \
  --count 1 \
  --subnet-id "$PRIVATE_SUBNET_A_ID" \
  --key-name  "$KEY_NAME" \
  --security-group-ids "$SG_PRIVATE_ID" \
  --no-associate-public-ip-address \
  --user-data file://instance_userdata.txt  \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$EC2_NAME},{Key=AgedTime,Value=$stop_time},{Key=scheduler:ec2-startstop,Value=$RULE}]"  \
  --block-device-mappings file://mapping.json \
  --query 'Instances[*].InstanceId' --output text)

private_ip_address=$(aws ec2 describe-instances \
    --instance-ids "$instance_id" \
    --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

#  Check instance status and wait instance is running status
print_color "green" "------Check instance status and wait instance is running status--------"
#instance-state-name - The state of the instance (pending | running | shutting-down | terminated | stopping | stopped ).
while true
do
  state=$(aws ec2 describe-instances \
      --instance-ids "$instance_id" \
      --query "Reservations[*].Instances[*].State.Name" --output text)
  echo $state
  if [[ $state == 'running' ]]; then
    print_color "green" "Successed. Instance is running."
    break
  fi
done

# Print out instance_id and private ip. 
print_color "green" "-------------------------print out instance id and private ip--------------------------"
print_color "green" "Outputs: InstanceId=\"$instance_id\", PrivateIpAddress=\"$private_ip_address\""

# Clean up the tempt file
rm ./instance_userdata.txt
rm ./mapping.json