output "s3_web_hosting_output" {
  description = "S3 hosting URL (HTTP)"
  value       = aws_s3_bucket_website_configuration.hosting
}

output "s3_bucket_output" {
  description = "Info about the S3 bucket created"
  value       = aws_s3_bucket.bucket
}
