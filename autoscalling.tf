# Define Auto Scaling Launch Configuration
resource "aws_launch_configuration" "web_server_config" {
  name          = "web-server-config"
  image_id      = "ami-05ffe3c48a9991133"  # Replace with the appropriate AMI ID (Amazon Linux 2 or Ubuntu)
  instance_type = "t2.micro"                # Use t2.micro to stay within the Free Tier

  security_groups = [aws_security_group.app_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

# Define Auto Scaling Group
resource "aws_autoscaling_group" "web_server_asg" {
  desired_capacity     = 1  # Start with one instance
  max_size             = 2  # Maximum of two instances
  min_size             = 1  # Minimum of one instance
  vpc_zone_identifier  = [aws_subnet.main_subnet.id]
  launch_configuration = aws_launch_configuration.web_server_config.id

  target_group_arns = [aws_lb_target_group.app_target_group.arn]

  health_check_type          = "EC2"
  health_check_grace_period = 300
  wait_for_capacity_timeout  = "0"

  tag {
    key                 = "Name"
    value               = "WebServerInstance"
    propagate_at_launch = true
  }
}
