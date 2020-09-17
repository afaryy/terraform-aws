variable "AWS_REGION" {
  default = "ap-southeast-2"
}

variable "AMIS" {
  type = map(string)
  default = {
    ap-southeast-2 = "ami-0ded330691a314693"
  }
}

 # centos "ami-05f50d9ec7e4c3b02" 


variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "tdl02"
}