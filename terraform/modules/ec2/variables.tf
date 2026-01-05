# Input Variables
variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "volume_type" {
  type = string
}

variable "runner_name" {
  type = string
}

variable "lt_prefix" {
  type = string
}

variable "lt_name" {
  type = string
}

variable "asg_name" {
  type = string
}

# Reference
variable "private_subnets" {
  type = list(string)
}

variable "ec2_app_sg" {
  type = string
}

variable "ec2_runner_sg" {
  type = string
}

variable "instance_profile" {
  type = string
}

variable "target_group_arn" {
  type = string
}