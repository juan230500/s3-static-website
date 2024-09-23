# Provider Block: Specifies the AWS provider and region
provider "aws" {
  region = "us-east-1"
}

# Resource Block: Creates an S3 bucket for hosting a static website
resource "aws_s3_bucket" "static_website_bucket" {
  bucket = var.bucket_name
}

# Resource Block: Enables versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.static_website_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Resource Block: Configures the S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.static_website_bucket.id

  # Specify index document
  index_document {
    suffix = "index.html"
  }

  # Specify error document
  error_document {
    key = "error.html"
  }
}

# Resource Block: Upload the index HTML file to the S3 bucket
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_website_bucket.id
  key          = "index.html"
  source       = "../website/index.html" # Path to the index file
  content_type = "text/html"
}

# Resource Block: Upload the error HTML file to the S3 bucket
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.static_website_bucket.id
  key          = "error.html"
  source       = "../website/error.html" # Path to the error file
  content_type = "text/html"
}

# Resource Block: Allows public access to the S3 bucket files
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_website_bucket.arn}/*"
      }
    ]
  })
}

# Resource Block: Configure public access settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.static_website_bucket.id

  # Allow public access to objects
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
