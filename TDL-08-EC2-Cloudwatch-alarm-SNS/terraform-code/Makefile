BUCKET_NAME=$(shell sed -ne '/bucket_name/,+5 p' variables.tf|grep default|awk '{print $$3}'|tr -d '"')
PREFIX=$(shell sed -ne '/prefix/,+5 p' variables.tf|grep default|awk '{print $$3}'|tr -d '"')

all : uploadconfigfile plan apply

.PHONY: uploadconfigfile # Upload the config file to the bucket
uploadconfigfile: 
	if [ -d "upload" ]; then aws s3 sync upload s3://${BUCKET_NAME}/${PREFIX}; fi

.PHONY: plan # run terraform plan
plan:
	terraform fmt;terraform init;terraform refresh;terraform plan -out tfplan

PHONY: apply # run terraform apply
apply:
	terraform apply tfplan

.PHONY:destroy # Destroy the AWS resources created by terraform
destroy:
	terraform destroy -auto-approve