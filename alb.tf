# Reference the existing security group
data "aws_security_group" "alb_sg" {
  name   = "alb-security-group"  # The name of your existing security group
  vpc_id = aws_vpc.main_vpc.id   # The VPC where the security group exists
}

# Reference the existing ALB target group
data "aws_lb_target_group" "app_target_group" {
  name = "app-target-group"  # Replace with your existing target group name
}

# Reference the existing ALB
data "aws_lb" "app_alb" {
  name = "app-alb"  # Replace with the name of your existing ALB
}

# Create a listener for the Load Balancer (HTTP)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = data.aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = "Welcome to the ALB!"
    }
  }
}

# Register EC2 instances as targets in the target group
resource "aws_lb_target_group_attachment" "ec2_attachment" {
  target_group_arn = data.aws_lb_target_group.app_target_group.arn
  target_id        = aws_instance.web_server.id  # Attach the EC2 instance to the target group
  port             = 80
}
