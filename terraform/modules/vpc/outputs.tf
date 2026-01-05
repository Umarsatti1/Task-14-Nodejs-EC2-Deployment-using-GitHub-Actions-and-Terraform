output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "public_subnets" {
  value       = [for subnet in aws_subnet.public_subnet : subnet.id]
  description = "VPC public subnet IDs"
}

output "private_subnets" {
  value       = [for subnet in aws_subnet.private_subnet : subnet.id]
  description = "VPC private subnet IDs"
}

output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "ALB security group ID"
}

output "runner_sg_id" {
  value       = aws_security_group.runner_sg.id
  description = "GitHub Runner EC2 instance security group ID"
}

output "app_sg_id" {
  value       = aws_security_group.app_sg.id
  description = "Application EC2 instances security group ID"
}