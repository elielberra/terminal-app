terraform {
  backend "s3" {
    bucket = "terminal-app-tfstate-555083284676"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"

    encrypt = true
    # Native S3 locking via a conditional-write lock object in the same
    # bucket — no DynamoDB table needed. Requires Terraform >= 1.11.
    use_lockfile = true
  }
}
