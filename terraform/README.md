# Terraform — website health monitoring

Provisions monitoring for elielberra.com:

- **Route 53 health check** — HTTPS probe of `var.domain_name` every 30s, unhealthy after 3 consecutive failures
- **CloudWatch alarm** — watches the health check's `HealthCheckStatus` metric (must live in `us-east-1`, see [versions.tf](versions.tf))
- **SNS topic + email subscription** — the alarm notifies this topic on both ALARM and OK transitions

## Usage

Requires AWS credentials with permission to manage Route 53, CloudWatch, and SNS resources (e.g. via `AWS_PROFILE` or `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`).

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

After `apply`, check the inbox for `var.alert_email` and click the SNS subscription confirmation link — no alerts are delivered until that's confirmed.

## Variables

| Variable | Default | Description |
|---|---|---|
| `domain_name` | `elielberra.com` | Domain the health check monitors |
| `alert_email` | `berraeliel@gmail.com` | Email notified on health check status change |

## Cost

~$1/month for the domain-based HTTPS health check, ~$0.10/month for the CloudWatch alarm (often free under the always-free alarm tier), SNS email is free at this volume.
