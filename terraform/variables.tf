# VPC Module
variable "vpc_cidr" {
  type        = string
  description = "VPC IPv4 CIDR block"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "igw_name" {
  type        = string
  description = "Internet gateway name"
}

variable "eip_domain" {
  type        = string
  description = "Elastic IP domain"
}

variable "public_route" {
  type        = string
  description = "All traffic 0.0.0.0/0"
}

variable "fetch_ip" {
  type        = string
  description = "Fetch My IP"
}

# IAM Module
variable "ec2_role" {
  type        = string
  description = "EC2 Instance IAM role name"
}

variable "instance_profile" {
  type        = string
  description = "EC2 Instance profile name"
}

# EC2 Module
variable "ami_id" {
  type        = string
  description = "Ubuntu Linux 24.04 LTS AMI ID us-west-1"
}

variable "instance_type" {
  type        = string
  description = "Ubuntu Linux instance type"
}

variable "volume_size" {
  type        = number
  description = "EBS volume size in GiB"
}

variable "volume_type" {
  type        = string
  description = "EBS volume type"
}

variable "runner_name" {
  type        = string
  description = "GitHub self-hosted runner instance name"
}

variable "lt_prefix" {
  type        = string
  description = "Launch template prefix name"
}

variable "lt_name" {
  type        = string
  description = "Launch template instance name"
}

variable "asg_name" {
  type        = string
  description = "Auto scaling group name"
}

# ALB Module
variable "lb_name" {
  type        = string
  description = "Load balancer name"
}

variable "lb_type" {
  type        = string
  description = "Load balancer type"
}

variable "tg_name" {
  type        = string
  description = "Target group name"
}

variable "tg_port" {
  type        = number
  description = "Target group port"
}

variable "tg_protocol" {
  type        = string
  description = "Target group protocol"
}

variable "protocol_version" {
  type        = string
  description = "Target group protocol version"
}

variable "tg_type" {
  type        = string
  description = "Target group type"
}

variable "listener_port" {
  type        = number
  description = "Listener port"
}

variable "listener_protocol" {
  type        = string
  description = "Listener protocol"
}

variable "listener_type" {
  type        = string
  description = "Listener type"
}