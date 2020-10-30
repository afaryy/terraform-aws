variable "project_name" {
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "traffic_type" {
  type        = string
  description = "Traffic Type"
}

variable "vpc_flowlog_log_group_name" {
  type        = string
  description = "Log group name - pushing VPC Flowlog to Cloudwatch Logs"
}
