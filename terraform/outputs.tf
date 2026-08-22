output "health_check_id" {
  value = aws_route53_health_check.site.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.website_health_alerts.arn
}

output "cloudwatch_alarm_name" {
  value = aws_cloudwatch_metric_alarm.site_down.alarm_name
}
