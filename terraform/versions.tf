terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # Route 53 health check CloudWatch metrics only exist in us-east-1,
  # regardless of which region the monitored endpoint is in.
  region = "us-east-1"
}
