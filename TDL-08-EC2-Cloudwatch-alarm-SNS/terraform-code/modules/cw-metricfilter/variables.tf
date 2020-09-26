variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "log_group_name" {
  type        = string
}

variable "filter_name" {
  type        = string
}

variable "filter_pattern" {
  type        = string
}

variable "metric_namespace" {
  type        = string
}

variable "metric_name" {
  type        = string
}

variable "metric_value" {
  type        = number
}

variable "metric_default_value" {
  type        = number
}
