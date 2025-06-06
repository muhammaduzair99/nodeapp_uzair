resource "aws_lb_target_group" "node_app_tg" {
  name     = "node-app-tg"
  port     = 3000
  protocol = "HTTP"
vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "node-app-tg"
  }
}
