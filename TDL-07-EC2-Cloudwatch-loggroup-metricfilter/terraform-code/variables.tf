variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "tdl7"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name that store cloudwatch agent config file "
  default = "project-stack-bucket"
}

variable "prefix" {
  type        = string
  description = "path/to/files"
  default = "tdl7-bucket/"
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

variable "log_group_name" {
  description = "log_group_name"
  type        = string
  default     = "apache-access-log" 
}

variable "filter_name" {
  type        = string
  default     = "HTTP404Errors" 
}

variable "filter_pattern" {
  type        = string
  default     = "[host, logName, user, timestamp, request, statusCode=404, size]" 
}

variable "metric_namespace" {
  type        = string
  default     = "myMetricNameSpace"
}

variable "metric_name" {
  type        = string
  default     = "urlNotFound"
}

variable "metric_value" {
  type        = number
  default     = 1
}

variable "metric_default_value" {
  type        = number
  default     = 0
}
