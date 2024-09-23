# Variable Block: Defines the bucket name as a variable for flexibility
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "my-static-website-bucket-67567"
}
