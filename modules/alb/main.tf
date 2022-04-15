resource "aws_alb" "tf_alb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets_ids

  enable_deletion_protection = true
  tags = {
    Name = "Demo ALB"
  }
}

resource "aws_alb_target_group" "tf_tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "10"
    protocol            = "HTTP"
    matcher             = "200"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "demo" {
  load_balancer_arn = aws_alb.tf_alb.id
  port              = var.target_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.tf_tg.id
    type             = "forward"
  }
}

resource "aws_alb_target_group_attachment" "alb_tg_attachment" {
  count            = var.amount
  target_group_arn = aws_alb_target_group.tf_tg.arn
  port             = var.target_port
  target_id        = var.instance_ids[count.index]
}

/*
resource "aws_alb_target_group_attachment" "alb_tg_attachment2" {
  target_group_arn = aws_alb_target_group.tf_tg.arn
  port             = var.target_port
  target_id        = var.instance_ids[1]
}
*/
