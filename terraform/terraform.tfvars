# VPC Module Vars
vpc_cidr     = "192.168.0.0/16"
vpc_name     = "umarsatti-vpc"
igw_name     = "umarsatti-igw"
eip_domain   = "vpc"
public_route = "0.0.0.0/0"
fetch_ip     = "https://api.ipify.org"

# IAM Module Vars
ec2_role         = "github-actions-ec2-iam-role"
instance_profile = "github-actions-iam-instance-profile"

# EC2 Module Vars
ami_id        = "ami-0e6a50b0059fd2cc3"
instance_type = "t2.small"
volume_size   = 20
volume_type   = "gp3"
runner_name   = "github-self-hosted-runner"
lt_prefix     = "nodejs-app-"
lt_name       = "nodejs-app"
asg_name      = "nodejs-app-asg"

# ALB Module Vars
lb_name           = "alb-nodejs-app"
lb_type           = "application"
tg_name           = "nodejs-target-group"
tg_port           = 3000
tg_protocol       = "HTTP"
protocol_version  = "HTTP1"
tg_type           = "instance"
listener_port     = 80
listener_protocol = "HTTP"
listener_type     = "forward"