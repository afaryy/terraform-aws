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

module "vpc-flowlog" {
  source                                = "./modules/vpc-flowlog" 
  project_name                          = var.project_name
  vpc_id                                = var.vpc_id
  traffic_type                          = var.traffic_type
  vpc_flowlog_log_group_name            = var.vpc_flowlog_log_group_name
}