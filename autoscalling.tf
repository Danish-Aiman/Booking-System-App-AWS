# Define Auto Scaling Launch Template
resource "aws_launch_template" "web_server_template" {
  name_prefix   = "web-server-template"
  image_id      = "ami-05ffe3c48a9991133"  # Replace with the appropriate AMI ID
  instance_type = "t2.micro"                # Use t2.micro to stay within the Free Tier

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
  launch_template {
    id      = aws_launch_template.web_server_template.id
    version = "$Latest"
  }

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
