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

variable "path_source_code" {
  default = "lambda_function"
}

/*
variable "path_dependencies" {
  description = "Path to create dependecies"
  default = "lambda_libs"
}
*/
variable "function_name" {
  default = "terminate_aged_instances_with_snapshots"
}

variable "layer_name" {
  default = "terminate_aged_instances_layer"
}

variable "runtime" {
  default = "python3.8"
}

variable "output_path" {
  description = "Path to function's deployment package into local filesystem. eg: /path/lambda_function.zip"
  default = "package_zip/lambda_function.zip"
}

variable "output_path_dependencies" {
  description = "Path to function's deployment package into local filesystem. eg: /path/lambda_function.zip"
  default = "package_zip/lambda_libs.zip"
}

