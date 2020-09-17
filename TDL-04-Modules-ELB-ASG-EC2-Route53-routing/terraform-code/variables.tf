
variable "AWS_REGION" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-2"
}


variable "AMIS" {
  type = map(string)
  description = "AMIS"
  default = {
    ap-southeast-2 = "ami-0ded330691a314693"
  }
}

variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "tdl04"
}

variable "stack_name" {
  type        = string
  description = "stack Name"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "ssl_certificate_id" {
  description = "Enter your certificate arn from ACM"
  type        = string
  default     ="arn:aws:acm:ap-southeast-2:421117346104:certificate/3699ca25-e7cd-4157-aef6-0a680a51652e"
}

variable "zone_id" {
  description = "Enter your zone ID "
  type        = string
  default     = "Z0487567QK3UCA9HOK0T"
}


variable "dns_name" {
  description = "DNS name for the ACM certificate"
  type        = string
  default     = "demo"
}

variable "elb_name_green" {
  description = "ELB name of green stack"
  type        = string
  default     = ""
}

variable "elb_name_blue" {
  description = "ELB name of blue stack"
  type        = string
  default     = ""
}

variable "elb_zoneid_green" {
  description = "ELB Zoneid of blue stack"
  type        = string
  default     = ""
}

variable "elb_zoneid_blue" {
  description = "ELB Zoneid of green stack"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-02ec2836691642ace"
}

variable "subnets" {
  description = "List of subnet IDs to use"
  type        = list(string)
  default     = ["subnet-04709dce111382a62","subnet-00d8a496401ddc8de"]
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to."
  type        = list(string)
  default     = ["sg-01aac9b3d4540fb5f"]
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key."
  type        = string
  default     = ""
}

variable "your_home_network_cidr" {
  type        = string
  description = "Your home network CIDR"
  default     = "120.148.174.1/32"
}

variable "blue_weight" {
  type        = number
  description = "blue weight"
  default     = 20
}

variable "green_weight" {
  type        = number
  description = "green weight"
  default     = 80
}

variable "ttl" {
  type        = string
  description = "records ttl"
  default     = 60
}

