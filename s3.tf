# Create an S3 Bucket for file storage
data "aws_s3_bucket" "app_bucket" {
  bucket = "web-app-file-storage-bucket"
}

# Create Block Public Access settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "app_bucket_public_access" {
  bucket = data.aws_s3_bucket.app_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "app_file" {
  bucket = data.aws_s3_bucket.app_bucket.bucket
  key    = "private_key.pem"  # The name of the file to be uploaded
  acl    = "private"  # Ensure the object is private
  source = ".ssh/id_ed25519"
}
