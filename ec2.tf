# Private Key for SSL certificate
resource "tls_private_key" "example_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Self-signed SSL Certificate
resource "tls_self_signed_cert" "ssl_cert" {
  private_key_pem = tls_private_key.example_key.private_key_pem
  validity_period_hours = 8760  # 1 year

  subject {
    common_name = "booking-system.com"  # Replace with your domain name
    organization = "MMU"
    country      = "MY"
  }

  allowed_uses = ["server_auth"]  # Set allowed use for server authentication
}


# Referencing the existing key pair
data "aws_key_pair" "web_server_key" {
  key_name   = "web-key"  # Name of the key pair
public_key = file("SSL/certificate/web-server-key.pem")
}

# Define the EC2 instance for the web server
resource "aws_instance" "web_server" {
  ami           = "ami-05ffe3c48a9991133"  # Replace with a valid AMI ID for your region (Amazon Linux, Ubuntu, etc.)
  instance_type = "t2.micro"  # Specify instance type (t2.micro is eligible for the free tier)
  subnet_id     = aws_subnet.main_subnet.id  # Make sure this references the public subnet

  # Use the correct security group
  security_groups = [aws_security_group.app_sg.id]  # Or use aws_security_group.app_sg.id

  associate_public_ip_address = true  # Ensure public IP assignment for the EC2 instance

  tags = {
    Name = "WebServer"
  }

  # Optionally use user_data to bootstrap the server (install Apache/PHP)
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo yum install -y php php-mysqlnd
              sudo yum install -y mod_ssl
              sudo service httpd start
              sudo chkconfig httpd on
              
              echo '$data.aws_key_pair.web_server_key.private_key}' > .ssh/web-key.pem 

              # Create SSL directory
              sudo mkdir -p /etc/ssl/certs /etc/ssl/private

              # Create SSL directory
              sudo mkdir -p /etc/ssl/certs /etc/ssl/private

              # Create ssl.conf file on Apache
              sudo touch /etc/httpd/conf.d/ssl.conf

              # Restart Apache to apply changes
              sudo service httpd restart

              #Install phpMyAdmin
              wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
              tar -xvzf phpMyAdmin-latest-all-languages.tar.gz
              sudo mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin
              
              EOF
}

output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "key_pair_name" {
  value = data.aws_key_pair.web_server_key.key_name
}
