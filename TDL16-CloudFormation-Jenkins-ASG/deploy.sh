#!/bin/bash
# 
# deploy.sh
#   Shell script to deploy Aws EC2/RDS Scheduer 
# Dependecy: 
#   - pip
#   - AWS CLI configured with credential and default AWS regions
# Reference: https://aws.amazon.com/answers/infrastructure-management/ec2-scheduler/
# Author: Eric Ho (eric.ho@datacom.com.au, hbwork@gmail.com, https://www.linkedin.com/in/hbwork/)
#

#Stack Deploy Parameters
TemplateName=${1:-cf-deploy-jenkins-asg.yaml}
StackName=${2:-testjenkins}

# AWS CLI default profile 
ProfileName=${3:-default}
ParametersFile="parameters.json"

# End of Customzation 
aws cloudformation validate-template --template-body file://${TemplateName}  > /dev/null || {
    echo "CF template ${TemplateName} validate error, exit!"
    exit 1
}

set +e

StackStatus=$(aws cloudformation describe-stacks --stack-name ${StackName} --query Stacks[0].StackStatus --output text)

set -e

if [ ${#StackStatus} -eq 0 ]
then
    echo "Please ignore the Validation Error messagege above. Create CloudFormation stack ${StackName} ..."

    aws cloudformation create-stack --stack-name ${StackName} \
		--template-body file://${TemplateName} \
    	--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
    	--profile ${ProfileName} \
    	--parameters file://${ParametersFile}

    sleep 30

elif [ ${StackStatus} == 'CREATE_COMPLETE' -o ${StackStatus} == 'UPDATE_COMPLETE' ]
then
    echo "Update stack ${StackName} ..."

    ChangeSetName="${StackName}-$(uuidgen)"

    aws cloudformation create-change-set --stack-name ${StackName} \
        --template-body file://${TemplateName} \
    	--profile ${ProfileName} \
        --change-set-name ${ChangeSetName} \
        --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
        --parameters file://${ParametersFile}

    sleep 10

    ChangeSetStatus=$(aws cloudformation describe-change-set  \
    	--profile ${ProfileName} \
        --change-set-name ${ChangeSetName} \
        --stack-name ${StackName} \
        --query Status \
        --output text)

    #CREATE_IN_PROGRESS , CREATE_COMPLETE , or FAILED
    while [[ ${ChangeSetStatus} == 'CREATE_IN_PROGRES' ]]
    do
        sleep 30
        ChangeSetStatus=$(aws cloudformation describe-change-set \
            --change-set-name ${ChangeSetName} \
    	    --profile ${ProfileName} \
            --stack-name ${StackName} \
            --query Status \
            --output text)
    done

	if [[ ${ChangeSetStatus} == 'FAILED' ]]
	then
        StatusReason=$(aws cloudformation describe-change-set \
            --change-set-name ${ChangeSetName} \
    	    --profile ${ProfileName} \
            --stack-name ${StackName} \
            --query StatusReason \
            --output text)

        echo "Error: Create change set failed, Exit!"
        echo "Reason: ${StatusReason}"
        exit 1
    else
        echo "Execute change set ${ChangeSetName}"
        aws cloudformation execute-change-set --change-set-name ${ChangeSetName} --stack-name ${StackName} --profile ${ProfileName}
        sleep 30
    fi
else
    echo "Failed to create or update stack ${StackName} (Unexpected stack status: ${StackStatus})"
    exit 1
fi

StackStatus=$(aws cloudformation describe-stacks \
    --stack-name ${StackName} \
    --query Stacks[0].StackStatus \
    --output text  \
    --profile ${ProfileName})

#CREATE_IN_PROGRESS
#UPDATE_IN_PROGRESS

while [ $StackStatus == "CREATE_IN_PROGRESS" -o $StackStatus == "UPDATE_IN_PROGRESS" ]
do
    sleep 30
    StackStatus=$(aws cloudformation describe-stacks \
      --stack-name ${StackName} \
      --query Stacks[0].StackStatus \
      --output text  \
      --profile ${ProfileName})
done

# CREATE_COMPLETE
# UPDATE_COMPLETE
# UPDATE_COMPLETE_CLEANUP_IN_PROGRESS
if [ $StackStatus != "CREATE_COMPLETE" -a $StackStatus != "UPDATE_COMPLETE_CLEANUP_IN_PROGRESS" -a $StackStatus != "UPDATE_COMPLETE" ]
then
    echo "Create/Update stack failed - ${StackStatus}"
    exit 1
fi

echo "Create/Update stack succeeded"
# __EOF__