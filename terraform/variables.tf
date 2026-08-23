variable "aws_region" {
  description = "Region for every resource in this module. Route 53 health check metrics only exist in us-east-1."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domain to monitor with the Route 53 health check"
  type        = string
  default     = "elielberra.com"
}

variable "alert_email" {
  description = "Email address subscribed to health check alerts"
  type        = string
  default     = "berraeliel@gmail.com"
}

variable "ssh_public_key" {
  description = "Public half of the admin SSH key (e.g. `ssh-keygen -y -f ~/.ssh/terminal-app.pem`). Not secret."
  type        = string
}

variable "ci_deploy_public_key" {
  description = "Public half of the GitHub Actions deploy keypair (matches the EC2_SSH_KEY repo secret). Not secret."
  type        = string
}

variable "eip_allocation_id" {
  description = "Allocation ID of the existing Elastic IP to re-associate (not managed by Terraform, so it can never be released by an apply/destroy)."
  type        = string
}

variable "onion_hostname" {
  description = "Expected .onion hostname, used by user_data to assert the restored Tor keys produced the right address."
  type        = string
  default     = "varayg7x6dwre6i5hbcyoxa5zi3t766lnlszvqawhmi6hdfx4c4dyxqd.onion"
}
