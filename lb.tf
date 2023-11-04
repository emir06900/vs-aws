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
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response_type = "200"
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

# Create Launch Configurations and Auto Scaling Groups

resource "aws_launch_configuration" "images_lc" {
  name                 = "images-lc"
  image_id             = "ami-12345678" # Specify the correct AMI ID
  instance_type        = "t2.micro"     # Choose the appropriate instance type
  security_groups      = ["sg-12345678"] # Specify the security group
  key_name             = "your-key-pair" # Add your key pair
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    sudo amazon-linux-extras install epel -y
    sudo yum install stress -y
    stress --cpu 2 --timeout 30000
    yum install -y htop
    EOF
}

resource "aws_launch_configuration" "videos_lc" {
  # Similar configuration as images_lc, but with different AMI, instance type, etc.
}

resource "aws_autoscaling_group" "images_asg" {
  name = "images-asg"
  launch_configuration = aws_launch_configuration.images_lc.name
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  target_group_arns    = [aws_lb_target_group.images_target_group.arn]
}

resource "aws_autoscaling_group" "videos_asg" {
  # Similar configuration as images_asg, but with different launch configuration and target group
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response_type = "200"
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




