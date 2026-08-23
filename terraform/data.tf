data "aws_caller_identity" "current" {}

# Latest Debian 13 arm64 AMI, not a pinned ID — picks up security updates on
# instance replacement. ec2.tf guards against surprise replacement with
# lifecycle { ignore_changes = [ami] }.
data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"] # Debian's official AWS account

  filter {
    name   = "name"
    values = ["debian-13-arm64-*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "default" {
  default = true
}

# Matches the current instance's placement (us-east-1c).
data "aws_subnet" "selected" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1c"
  default_for_az    = true
}
