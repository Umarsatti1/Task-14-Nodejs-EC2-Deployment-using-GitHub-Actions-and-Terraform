# GitHub Self-Hosted Runner EC2 (Single VM)
resource "aws_instance" "github_runner" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnets[0] # us-west-1a
  vpc_security_group_ids      = [var.ec2_runner_sg]
  iam_instance_profile        = var.instance_profile
  associate_public_ip_address = false

  user_data = templatefile("${path.root}/runner_ec2.sh", {
    cw_json = file("${path.root}/cloudwatch/runner_cw.json"),
  })

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  tags = {
    Name = var.runner_name
  }
}

# Launch Template for Application EC2
resource "aws_launch_template" "app_lt" {
  name_prefix   = var.lt_prefix
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile
  }

  vpc_security_group_ids = [var.ec2_app_sg]

  user_data = base64encode(
    templatefile("${path.root}/app_ec2.sh", {
      cw_json = file("${path.root}/cloudwatch/app_cw.json")
    })
  )

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.lt_name
    }
  }
}

# Auto Scaling Group for Application EC2
resource "aws_autoscaling_group" "app_asg" {
  name             = var.asg_name
  min_size         = 1
  max_size         = 2
  desired_capacity = 2

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  tag {
    key                 = "Name"
    value               = "nodejs-app"
    propagate_at_launch = true
  }
}