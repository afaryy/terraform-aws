variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "tdl14"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name that store cloudwatch agent config file "
  default = "project-stack-bucket"
}

variable "prefix" {
  type        = string
  description = "path/to/files"
  default = "tdl14-bucket/"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-2"
}

variable "AMIS" {
  type = map(string)
  description = "AMIS"
  default = {
    ap-southeast-2 = "ami-0099823645f06b6a1"
  }
}

variable "instance_type" {
  type        = string
  description = "Intance Type"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "key pair name"
  default     = "da-key"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-02ec2836691642ace"
}

variable "subnet" {
  description = "subnet ID"
  type        = string
  default     = "subnet-04709dce111382a62" 
}

/*
variable "log_group_name" {
  description = "log_group_name"
  type        = string
  default     = "apache-access-log" 
}
*/

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
