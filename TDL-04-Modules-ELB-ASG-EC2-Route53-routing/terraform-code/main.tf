module "kms" {
  source                  = "./modules/kms"
  project_name            = var.project_name
  #asg_role_name           = module.iam.asg_role_name
  #asg_role_arn          = module.iam.asg_role_arn
}


module "stack_blue" {
  source                  = "./modules/elb-asg"
  project_name            = var.project_name
  stack_name              = "blue"
  AWS_REGION              = var.AWS_REGION
  AMIS                    = var.AMIS
  vpc_id                  = var.vpc_id
  subnets                 = var.subnets
  allowed_security_groups = var.allowed_security_groups
  ssl_certificate_id      = var.ssl_certificate_id
  kms_key_arn             = module.kms.kms_key_arn
  #instance_profile       = module.iam.instance_profile
}

module "stack_green" {
  source                  = "./modules/elb-asg"
  project_name            = var.project_name
  stack_name              = "green"
  AWS_REGION              = var.AWS_REGION 
  AMIS                    = var.AMIS
  vpc_id                  = var.vpc_id
  subnets                 =var.subnets
  allowed_security_groups = var.allowed_security_groups
  ssl_certificate_id      = var.ssl_certificate_id
  kms_key_arn             = module.kms.kms_key_arn
  #instance_profile        = module.iam.instance_profile
}

module "records" {
  source            = "./modules/route53"
  blue_weight       = var.blue_weight
  green_weight      = var.green_weight
  ttl               = var.ttl
  zone_id           = var.zone_id
  dns_name          = var.dns_name
  elb_name_green    = module.stack_green.elb_name
  elb_zoneid_green  = module.stack_green.elb_zoneid
  elb_name_blue     = module.stack_blue.elb_name 
  elb_zoneid_blue   = module.stack_blue.elb_zoneid
}

