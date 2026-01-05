output "alb_dns" {
  value       = module.alb.load_balancer_dns
  description = "ALB DNS name for application access"
}

output "runner_ip" {
  value       = module.ec2.runner_ip
  description = "GitHub Runner EC2 instance private IPv4 address"
}
