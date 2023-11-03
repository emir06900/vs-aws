# Create an Application Load Balancer
resource "aws_lb" "my_alb" {
  name               = "my-application-load-balancer"
  internal           = false # Set to true if internal ALB is needed
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

# Create /path rules for the ALB
resource "aws_lb_listener_rule" "itmeme" {
  listener_arn = aws_lb.my_alb.arn
  action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      content      = "Images"
    }
  }

  condition {
    path_pattern {
      values = ["/itmeme/*"]
    }
  }
}

resource "aws_lb_listener_rule" "video" {
  listener_arn = aws_lb.my_alb.arn
  action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      content      = "Videos"
    }
  }
  condition {
    path_pattern {
      values = ["/video/*"]
    }
  }
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