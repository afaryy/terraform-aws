#!/bin/bash
#
# Deploy AWS instance.
# Author: Yvonne Yao

export AWS_DEFAULT_REGION='ap-southeast-2'
DEFAULT_TIME_ZONE='Australia/Melbourne'
declare -a LIST_OSTYPE
LIST_OSTYPE=('amzn' 'amzn2' 'centos6' 'centos7' 'ubuntu')
declare -a LIST_INSTANCE_TYPE
LIST_INSTANCE_TYPE=('t2.micro' 't2.small' 't3.micro')
instance_type='t2.micro' #default value

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
#   usage_type. eg: all, ostype, agedtime, instance_type.
#######################################
function usage(){
  case "$1" in
    all)
      print_color "red" "To deploy your instance, please run deploy_instance.sh as follows:"
      print_color "red" "./deploy_instance.sh ostype agedtime [instance_type]"
      print_color "red" "The value range of the arguments: "
      print_color "red" "1. valid ostype: amzn, amzn2, centos6, centos7, ubuntu"
      print_color "red" "2. agedtime: 1-7 "
      print_color "red" "3. instance_type: default t2_micro, valid instance_type: t2.micro, t2.small, t3.micro"
      ;;
    ostype)
      print_color "red" "Please input valid ostype: amzn, amzn2, centos6, centos7, ubuntu"
      ;;
    agedtime)
      print_color "red" "Please input valid agedtime: 1-7 "
      ;;
    instance_type)
      print_color "red" "Please input valid instance_type: default t2_micro, other valid instance_type: t2.micro, t2.small, t3.micro"
      ;;
    *)
      error "Unexpected expression '$1'"
      ;;
  esac
}

# check input
print_color "green" "-----------------------------Your input:-------------------------------"
echo "ostype=$1,agetime=$2,instance_type=$3"
print_color "green" "-----------------------------Check input-------------------------------"

# if less than 2 parameters from command line, print usage() and exit
if [[ $# -lt 2 || $# -gt 3 ]];  then
  usage 'all'
  exit
fi

# check whehter ostype is a valid option, if ostype is an invalid ostype, print usage() and exit 
list_include_item "${LIST_OSTYPE[*]}" "$1"
result=$?
if (( result == 1 )); then
  usage 'ostype'
  exit
fi
ostype=$1

# check whether 1 <= agedtime <=7, otherwise iprint usage() and exit
if (( $2 <1 || $2 > 7)); then
  usage 'agedtime'
  exit
fi
agedtime=$2

# check whether instance_type is valid, otherwise iprint usage() and exit
if [[ $# -eq 3 ]];  then
  list_include_item "${LIST_INSTANCE_TYPE[*]}" "$3"
  result=$?
  if (( result == 1 )); then
    usage 'instance_type'
    exit
  fi
  instance_type=$3
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
# set variables
KEY_NAME='da-key'
VPC_NAME='da-c02-vpc'
VPC_ID=$(aws ec2 describe-vpcs \
    --filter "Name=tag:Name,Values=$VPC_NAME" \
    --query Vpcs[].VpcId --output text)
echo $VPC_ID
PRIVATE_SUBNET_A_NAME='da-c02-private-a'
PRIVATE_SUBNET_A_ID=$(aws ec2 describe-subnets  \
    --filter "Name=tag:Name,Values=$PRIVATE_SUBNET_A_NAME" \
    --query 'Subnets[].SubnetId' --output text)
echo "${PRIVATE_SUBNET_A_ID}"

SG_PRIVATE_NAME='da-c02-private-sg'
SG_PRIVATE_ID=$(aws ec2 describe-security-groups \
    --filters Name=vpc-id,Values="${VPC_ID}" Name=group-name,Values="${SG_PRIVATE_NAME}" \
    --query  'SecurityGroups[*].[GroupId]'  --output text)
echo "${SG_PRIVATE_ID}"

# start_time=$(date -d "$(TZ='Australia/Melbourne' date)" +%Y%m%d%H%M%S)
# echo ${start_time}
## AgedTime: yyyymmddhhmm (current time + agedtime days in Australia/Melbourne Time)
stop_time=$(date -d "$(TZ=$DEFAULT_TIME_ZONE date) $agedtime days -3600 seconds" +%Y%m%d%H%M%S)
echo ${stop_time}

# Create user_data file
cat << EOF > ./instance_userdata.txt
#!/bin/bash
cat <<EOT >> /etc/motd
'OSType: $ostype'
"Please be notified that your instance will be terminated by  ${stop_time}"
EOT
EOF

EC2_NAME='ostype_test'
RULE='ec2-startstop;1900;;all'
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
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$EC2_NAME},{Key=AgedTime,Value=$stop_time},{Key=scheduler,Value=$RULE}]"  \
    --query 'Instances[*].InstanceId' --output text)

private_ip_address=$(aws ec2 describe-instances \
    --filter "Name=tag:Name,Values=$EC2_NAME" \
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

# Print out private ip and 
print_color "green" "-------------------------print out instance id and private ip--------------------------"
print_color "green" "Outputs: InstanceId=\"$instance_id\", PrivateIpAddress=\"$private_ip_address\""