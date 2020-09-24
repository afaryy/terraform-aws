module "ec2-cwagent" {
  source                  = "./modules/ec2-cwagent" 
  project_name            = var.project_name
  bucket_name             = var.bucket_name
  prefix                  = var.prefix
  aws_region              = var.aws_region
  AMIS                    = var.AMIS
  instance_type           = var.instance_type
  key_name                =var.key_name
  vpc_id                  = var.vpc_id
  subnet                  = var.subnet
}

module "filter" {
  source                  = "./modules/cw-metricfilter" 
  project_name            = var.project_name
  log_group_name          = var.log_group_name
  filter_name             = var.filter_name
  filter_pattern          = var.filter_pattern
  metric_namespace        = var.metric_namespace
  metric_name             = var.metric_name
  metric_value            = var.metric_value
  metric_default_value    = var.metric_default_value
}
