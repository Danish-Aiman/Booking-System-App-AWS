# Create a VPC for isolating resources
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"  # Define the CIDR block for the VPC
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Create a public subnet for placing EC2 instances in us-east-1a
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"  # Public subnet CIDR block
  availability_zone       = "us-east-1a"    # Availability zone for the subnet
  map_public_ip_on_launch = true             # Ensure EC2 instances in this subnet get a public IP

  tags = {
    Name = "main-subnet"
  }
}

# Create another public subnet in availability zone us-east-1b
resource "aws_subnet" "second_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.3.0/24"  # Public subnet CIDR block for the second subnet
  availability_zone       = "us-east-1b"    # New Availability zone (us-east-1b)
  map_public_ip_on_launch = true             # Ensure EC2 instances in this subnet get a public IP

  tags = {
    Name = "second-subnet"
  }
}

# Create an Internet Gateway to allow communication with the internet
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main-igw"
  }
}

# Create a route table for public access
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  # Route for public subnet to access the internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the route table with the public subnet in us-east-1a
resource "aws_route_table_association" "public_route_table_association_a" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate the route table with the public subnet in us-east-1b
resource "aws_route_table_association" "public_route_table_association_b" {
  subnet_id      = aws_subnet.second_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}