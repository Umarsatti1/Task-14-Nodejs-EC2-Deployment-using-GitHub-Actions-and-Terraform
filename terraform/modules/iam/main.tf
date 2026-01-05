# 1. EC2 Instance Profile IAM Role

# EC2 Trust relationship
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# EC2 IAM Role
resource "aws_iam_role" "ec2_instance_role" {
  name               = var.ec2_role
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Attach AWS Managed Policies
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cwagent_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Custom IAM Policy (from external JSON document)
resource "aws_iam_policy" "autoscaling_ec2_policy" {
  name        = "github-actions-ec2-autoscaling"
  description = "Custom policy for GitHub runner EC2 instance"

  policy = file("${path.root}/ec2_autoscaling_policy.json")
}

# Attach Custom Inline Policy
resource "aws_iam_role_policy_attachment" "ec2_custom_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.autoscaling_ec2_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = var.instance_profile
  role = aws_iam_role.ec2_instance_role.name
}