variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "tdl6"
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

variable "bucket_name" {
  type        = string
  description = "Bucket name that store cloudwatch agent config file "
  default = "tdl6-bucket"
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