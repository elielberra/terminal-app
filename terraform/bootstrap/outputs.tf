output "state_bucket_name" {
  description = "S3 bucket name to reference in the root module's backend.tf"
  value       = aws_s3_bucket.tfstate.id
}

output "state_bucket_arn" {
  value = aws_s3_bucket.tfstate.arn
}
