resource "aws_lb" "load_balancer" {
  name                       = var.lb_name
  internal                   = false
  load_balancer_type         = var.lb_type
  security_groups            = [var.alb_sg]
  subnets                    = var.alb_subnet
  enable_deletion_protection = false

  tags = {
    Name = var.lb_name
  }
}

# Target group
resource "aws_lb_target_group" "ip_target_group" {
  name             = var.tg_name
  port             = var.tg_port
  protocol         = var.tg_protocol
  protocol_version = var.protocol_version
  target_type      = var.tg_type
  vpc_id           = var.vpc_id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = var.listener_type
    target_group_arn = aws_lb_target_group.ip_target_group.arn
  }
}