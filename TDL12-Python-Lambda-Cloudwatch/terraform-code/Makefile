all : plan apply

.PHONY: plan # run terraform plan
plan:
	terraform fmt;terraform init;terraform refresh;terraform plan -out tfplan

.PHONY: apply # run terraform apply
apply:
	terraform apply tfplan

.PHONY:destroy # Destroy the AWS resources created by terraform
destroy:
	terraform destroy -auto-approve