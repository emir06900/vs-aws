resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "My custom security group"

  vpc_id = aws_vpc.my_vpc.id  # Replace with your VPC ID

  # Inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["108.28.47.38/32"]  # Allow HTTP from anywhere
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["108.28.47.38/32"]  # Allow custom TCP (port 8080) from anywhere
  }
}

resource "aws_launch_configuration" "images_lc" {
  name_prefix                 = "images-"
  image_id                    = "ami-05990981fdac8ac90"  # Specify the desired AMI
  instance_type               = "t2.micro"                    # Adjust instance type
  security_groups = [aws_security_group.my_security_group.id] # Create this security group
  key_name                    = "projectt"               # Change to your key pair
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              sudo amazon-linux-extras install epel -y
              sudo yum install stress -y
              stress --cpu 2 --timeout 30000
              yum install -y htop
              EOF
}

resource "aws_launch_configuration" "videos_lc" {
  name_prefix                 = "videos-"
  instance_type               = "t2.micro"                    # Adjust instance type
  image_id                    = "ami-05990981fdac8ac90"  # Specify the desired AMI
  security_groups = [aws_security_group.my_security_group.id]     # Create this security group
  key_name                    = "projectt"               # Change to your key pair
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              sudo amazon-linux-extras install epel -y
              sudo yum install stress -y
              stress --cpu 2 --timeout 30000
              yum install -y htop
              EOF
}

resource "aws_autoscaling_group" "images_asg" {
  name                      = "images-autoscaling-group"
  launch_configuration      = aws_launch_configuration.images_lc.name
  vpc_zone_identifier       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  target_group_arns         = [aws_lb_target_group.images_tg.arn]
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300
  tag {
    key                 = "Name"
    value               = "images-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "videos_asg" {
  name                      = "videos-autoscaling-group"
  launch_configuration      = aws_launch_configuration.videos_lc.name
  vpc_zone_identifier       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  target_group_arns         = [aws_lb_target_group.videos_tg.arn]
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300
  tag {
    key                 = "Name"
    value               = "videos-instance"
    propagate_at_launch = true
  }
}