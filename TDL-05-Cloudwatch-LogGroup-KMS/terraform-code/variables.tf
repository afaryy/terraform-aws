variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "log_groups" {
    description = "list of log group"
    type = map
}