variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name that store cloudwatch agent config file "
}

variable "prefix" {
  type        = string
  description = "path/to/files"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "AMIS" {
  type = map(string)
  description = "AMIS"
}

variable "instance_type" {
  type        = string
  description = "Intance Type"
}

variable "key_name" {
  type        = string
  description = "key pair name"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet" {
  description = "subnet ID"
  type        = string
}