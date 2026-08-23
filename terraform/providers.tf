provider "aws" {
  # Route 53 health check CloudWatch metrics only exist in us-east-1,
  # regardless of which region the monitored endpoint is in. The EC2 host
  # lives in the same region, so a single provider covers everything.
  region = var.aws_region
}
