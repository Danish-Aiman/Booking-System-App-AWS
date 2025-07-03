# Define the RDS instance (MySQL in this case)
resource "aws_db_instance" "app_db" {
  engine            = "mysql"  # Set the database engine to MySQL
  instance_class    = "db.t3.micro"  # Instance size 
  allocated_storage = 20  # Storage size in GB
  storage_type      = "gp2"  # General Purpose SSD
  db_name           = "BookingSystem"  # The name of your database
  username          = "admin"  # Database username
  password          = "Winish-123"  # Database password (make sure to change it)
  vpc_security_group_ids = [aws_security_group.app_sg.id]  # Associate the security group
  db_subnet_group_name   = aws_db_subnet_group.app_db_subnet.id  # Database subnet group (private subnet)
  publicly_accessible = false  # Set to false to prevent public access (more secure)
  multi_az            = true                   # Enable Multi-AZ for high availability
  storage_encrypted   = true                   # Enable encryption for data at rest
  
  # Enable automatic backups
  backup_retention_period = 7  # Retain backups for 7 days

  # Maintenance settings
  maintenance_window = "Sun:23:00-Sun:23:30"  # Set a maintenance window

  tags = {
    Name = "BookingDatabase"
  }

  # Enable automatic minor version upgrade
  auto_minor_version_upgrade = true

  # Take a final snapshot before deletion
  final_snapshot_identifier = "app-db-final-snapshot"
  skip_final_snapshot = false
}

# Create a subnet group for RDS instances (private subnets for security)
resource "aws_db_subnet_group" "app_db_subnet" {
  name        = "app-db-subnet-group"
  subnet_ids  = [aws_subnet.main_subnet.id, aws_subnet.second_subnet.id]
  description = "Subnet group for RDS database"

  tags = {
    Name = "AppDBSubnetGroup"
  }
}
