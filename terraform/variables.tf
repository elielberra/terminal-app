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
