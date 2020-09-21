#!/bin/bash

# Upload the config file to the bucket
aws s3 cp ./config.json s3://tdl6-bucket/config.json

# Run terraform
cd ~/Repo/terraform-aws-project/TDL-06-EC2-Cloudwatch/terraform-code
terraform init
terraform apply



