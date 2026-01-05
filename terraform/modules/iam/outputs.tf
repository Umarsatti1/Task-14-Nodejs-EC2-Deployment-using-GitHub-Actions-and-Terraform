output "instance_profile" {
  value       = aws_iam_instance_profile.instance_profile.name
  description = "EC2 Instance Profile name for Runner and App EC2"
}