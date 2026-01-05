# VPC
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  vpc_name     = var.vpc_name
  igw_name     = var.igw_name
  eip_domain   = var.eip_domain
  public_route = var.public_route
  fetch_ip     = var.fetch_ip
}

# IAM
module "iam" {
  source           = "./modules/iam"
  ec2_role         = var.ec2_role
  instance_profile = var.instance_profile
}

# EC2
module "ec2" {
  source           = "./modules/ec2"
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  volume_size      = var.volume_size
  volume_type      = var.volume_type
  runner_name      = var.runner_name
  lt_prefix        = var.lt_prefix
  lt_name          = var.lt_name
  asg_name         = var.asg_name
  private_subnets  = module.vpc.private_subnets
  ec2_app_sg       = module.vpc.app_sg_id
  ec2_runner_sg    = module.vpc.runner_sg_id
  instance_profile = module.iam.instance_profile
  target_group_arn = module.alb.target_group_arn
}

# ALB
module "alb" {
  source            = "./modules/alb"
  lb_name           = var.lb_name
  lb_type           = var.lb_type
  tg_name           = var.tg_name
  tg_port           = var.tg_port
  tg_protocol       = var.tg_protocol
  protocol_version  = var.protocol_version
  tg_type           = var.tg_type
  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol
  listener_type     = var.listener_type
  vpc_id            = module.vpc.vpc_id
  alb_sg            = module.vpc.alb_sg_id
  alb_subnet        = module.vpc.public_subnets
}