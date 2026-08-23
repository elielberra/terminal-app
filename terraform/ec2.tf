resource "aws_key_pair" "admin" {
  key_name   = "terminal-app-admin"
  public_key = var.ssh_public_key
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.debian.id
  instance_type = "t4g.small"
  subnet_id     = data.aws_subnet.selected.id

  key_name               = aws_key_pair.admin.key_name
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.app.name

  credit_specification {
    cpu_credits = "unlimited"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true

    tags = {
      Name = "terminal-app-root"
    }
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data_replace_on_change = true
  user_data = templatefile("${path.module}/templates/user-data.sh.tftpl", {
    aws_region           = var.aws_region
    domain_name          = var.domain_name
    alert_email          = var.alert_email
    ci_deploy_public_key = var.ci_deploy_public_key
    expected_onion       = var.onion_hostname
    expected_public_ip   = data.aws_eip.app.public_ip
    ssm_env_prod         = aws_ssm_parameter.secret["env_prod"].name
    ssm_rag_chain_env    = aws_ssm_parameter.secret["rag_chain_env"].name
    ssm_tor_secret_key   = aws_ssm_parameter.secret["tor_hs_secret_key"].name
    ssm_tor_public_key   = aws_ssm_parameter.secret["tor_hs_public_key"].name
    ssm_tor_hostname     = aws_ssm_parameter.secret["tor_hs_hostname"].name
  })

  # A newly published Debian AMI must never silently destroy prod. Bump
  # deliberately by removing this and re-applying when a rebuild is wanted.
  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "terminal-app"
  }
}
