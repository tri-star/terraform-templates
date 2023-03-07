resource "aws_lb" "prod" {
  name               = "${var.prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.alb_sg.id
  ]
  subnets = var.subnets
}

resource "aws_lb_listener" "prod" {
  load_balancer_arn = aws_lb.prod.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg1.arn
    type             = "forward"
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}

resource "aws_lb_listener" "standby" {
  load_balancer_arn = aws_lb.prod.arn
  port              = 10080
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg2.arn
    type             = "forward"
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}


resource "aws_lb_target_group" "tg1" {
  name        = "${var.prefix}-tg-1"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }

  deregistration_delay = 100
}

resource "aws_lb_target_group" "tg2" {
  name        = "${var.prefix}-tg-2"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }

  deregistration_delay = 2
}
