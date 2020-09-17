
variable "AWS_REGION" {
  type        = string
  description = "AWS region"
}


variable "AMIS" {
  type = map(string)
  description = "AMIS"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "stack_name" {
  type        = string
  description = "stack Name"
}

variable "ssl_certificate_id" {
  description = "Enter your certificate arn from ACM"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs to use"
  type        = list(string)
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to."
  type        = list(string)
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key."
  type        = string
}










