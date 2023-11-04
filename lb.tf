# Create an Application Load Balancer
resource "aws_lb" "my_alb" {
  name               = "my-application-load-balancer"
  internal           = false # Set to true if internal ALB is needed
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}


# Create two Target Groups
resource "aws_lb_target_group" "images_tg" {
  name     = "images-target-group"
  port     = 80 # Adjust the port as needed
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

resource "aws_lb_target_group" "videos_tg" {
  name     = "videos-target-group"
  port     = 80 # Adjust the port as needed
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
  }
}

resource "aws_lb_listener_rule" "images_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.images_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/itmeme/*"]
    }
  }
}

resource "aws_lb_listener_rule" "videos_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.videos_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/video/*"]
    }
  }
}

