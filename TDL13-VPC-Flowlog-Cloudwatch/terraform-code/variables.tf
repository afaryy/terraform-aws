variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "tdl12"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name that store cloudwatch agent config file "
  default     = "project-stack-bucket"
}

variable "prefix" {
  type        = string
  description = "path/to/files"
  default     = "tdl12-bucket/"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-2"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-02ec2836691642ace"
}

variable "traffic_type" {
  type        = string
  description = "Traffic Type"
  default     = "ALL"
}

variable "vpc_flowlog_log_group_name" {
  type        = string
  description = "Log group name - pushing VPC Flowlog to Cloudwatch Logs"
  default     = "vpc_flowlog_loggroup"
}
