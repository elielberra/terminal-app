# Instance role. Every object here is named with a `terminal-app-` prefix so the
# Terraform principal's own policy can scope iam:* and iam:PassRole to exactly
# these resources rather than account-wide.
#
# Scope is deliberately minimal: this role only ever needs to read its own
# secrets from SSM at boot. The rag-chain store is built in place by
# vector_store.py, not restored from anywhere, so there is no S3 grant here.

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app" {
  name               = "terminal-app-instance"
  description        = "Role for the terminal-app EC2 host: read its secrets from SSM at boot"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "app_bootstrap_read" {
  statement {
    sid    = "ReadAppSecrets"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]
    resources = [for p in aws_ssm_parameter.secret : p.arn]
  }
}

resource "aws_iam_role_policy" "app_bootstrap_read" {
  name   = "terminal-app-bootstrap-read"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.app_bootstrap_read.json
}

resource "aws_iam_instance_profile" "app" {
  name = "terminal-app-instance"
  role = aws_iam_role.app.name
}
