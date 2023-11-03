resource "aws_launch_configuration" "images_lc" {
  name_prefix                 = "images-"
  image_id                    = "ami-035c22a887ed22046"  # Specify the desired AMI

  instance_type               = "t2.micro"                    # Adjust instance type
   # Create this security group
  key_name                    = "new-jenkins"               # Change to your key pair
  associate_public_ip_address = true
  
}

resource "aws_launch_configuration" "videos_lc" {
  name_prefix                 = "videos-"
  instance_type               = "t2.micro"                    # Adjust instance type
  image_id                    = "ami-035c22a887ed22046"  # Specify the desired AMI
 # Create this security group
  key_name                    = "new-jenkins"               # Change to your key pair
  associate_public_ip_address = true
  
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