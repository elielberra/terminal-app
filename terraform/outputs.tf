output "health_check_id" {
  value = aws_route53_health_check.site.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.website_health_alerts.arn
}

output "cloudwatch_alarm_name" {
  value = aws_cloudwatch_metric_alarm.site_down.alarm_name
}

output "instance_id" {
  value = aws_instance.app.id
}

output "public_ip" {
  description = "The associated Elastic IP."
  value       = aws_eip_association.app.public_ip
}

output "public_dns" {
  description = "Set this as the EC2_HOST GitHub secret if it changed."
  value       = aws_instance.app.public_dns
}

output "onion_hostname" {
  value = var.onion_hostname
}

output "ssh_command" {
  value = "ssh admin@${aws_instance.app.public_dns}"
}
