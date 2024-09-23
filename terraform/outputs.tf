# Output Block: Provides the S3 website URL after deployment
output "website_url" {
  description = "The URL for the S3 bucket website"
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
}
