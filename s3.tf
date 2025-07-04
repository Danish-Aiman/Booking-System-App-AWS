resource "random_id" "rand_id" {
  byte_length = 8
}

# Create an S3 Bucket for file storage
resource "aws_s3_bucket" "app_bucket" {
  bucket = "web-app-file-storage-bucket-${random_id.rand_id.hex}" 

  tags = {
    Name        = "AppFileStorage"
    Environment = "Production"
  }
}

# Create Block Public Access settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "app_bucket_public_access" {
  bucket = aws_s3_bucket.app_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "app_file" {
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "web-linux.pem"  # The name of the file to be uploaded
  acl    = "private"  # Ensure the object is private
  source = ".ssh/web-linux.pem"
}
