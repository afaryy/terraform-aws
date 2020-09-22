all : plan apply

.PHONY: plan # run terraform plan
plan:
	terraform init;terraform refresh;terraform plan -out project_plan

PHONY: apply # run terraform apply
apply:
	terraform apply project_plan

.PHONY:destroy # Destroy the AWS resources created by terraform
destroy:
	terraform destroy -auto-approve