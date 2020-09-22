#!/bin/bash

# Upload the config file to the bucket
bucketName=$(sed -ne '/bucket_name/,+5 p' ../variables.tf |grep default| awk '{print $3}' | tr -d '"')

# aws s3 cp upload/config.json s3://${bucketName}/config.json
if [ -d "../upload" ]; then
aws s3 sync ../upload s3://${bucketName};
fi

# Run terraform
cd ~/Repo/terraform-aws-project/TDL-06-EC2-Cloudwatch/terraform-code
terraform init
terraform plan -out project_plan
terraform apply project_plan



