# Secret plumbing only. Terraform creates these parameters as empty shells;
# the real values are inserted out-of-band with `aws ssm put-parameter` so that
# no secret ever passes through a .tfvars file or Terraform state.
#
# ignore_changes on `value` is what makes that safe: once a real value is
# written, Terraform stops seeing it as drift and never resets the placeholder.

locals {
  ssm_placeholder = "REPLACE_ME"

  ssm_secrets = {
    env_prod = {
      name        = "/terminal-app/env-prod"
      description = "Contents of terminal-app/.env.prod"
    }
    rag_chain_env = {
      name        = "/terminal-app/rag-chain-env"
      description = "Contents of rag-chain/.env"
    }
    tor_hs_secret_key = {
      name        = "/terminal-app/tor-hs-secret-key"
      description = "base64 of Tor hs_ed25519_secret_key"
    }
    tor_hs_public_key = {
      name        = "/terminal-app/tor-hs-public-key"
      description = "base64 of Tor hs_ed25519_public_key"
    }
    tor_hs_hostname = {
      name        = "/terminal-app/tor-hs-hostname"
      description = "The .onion hostname"
    }
  }
}

resource "aws_ssm_parameter" "secret" {
  for_each = local.ssm_secrets

  name        = each.value.name
  description = each.value.description
  type        = "SecureString"
  value       = local.ssm_placeholder

  lifecycle {
    ignore_changes = [value]
  }
}
