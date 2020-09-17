variable "blue_weight" {
  type        = number
  description = "blue weight"
}

variable "green_weight" {
  #type        = number
  #description = "green weight"
}

variable "ttl" {
  type        = string
  description = "records ttl"
}

variable "zone_id" {
  description = "Enter your zone ID "
  type        = string
}

variable "dns_name" {
  description = "DNS name for the ACM certificate"
  type        = string
}

variable "elb_name_green" {
  description = "ELB name of green stack"
  type        = string
}

variable "elb_name_blue" {
  description = "ELB name of blue stack"
  type        = string
}

variable "elb_zoneid_green" {
  description = "ELB Zoneid of blue stack"
  type        = string
}

variable "elb_zoneid_blue" {
  description = "ELB Zoneid of green stack"
  type        = string
}