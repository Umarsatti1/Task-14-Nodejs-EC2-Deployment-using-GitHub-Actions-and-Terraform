output "load_balancer_dns" {
  value = aws_lb.load_balancer.dns_name
}

output "load_balancer_arn" {
  value       = aws_lb.load_balancer.arn
  description = "Application load balancer ARN"
}

output "target_group_arn" {
  value       = aws_lb_target_group.ip_target_group.arn
  description = "Target group ARN"
}