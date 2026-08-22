resource "aws_cloudwatch_metric_alarm" "site_down" {
  alarm_name          = "${var.domain_name}-down"
  alarm_description   = "Route 53 health check reports ${var.domain_name} as unhealthy"
  namespace           = "AWS/Route53"
  metric_name         = "HealthCheckStatus"
  dimensions          = { HealthCheckId = aws_route53_health_check.site.id }
  statistic           = "Minimum"
  period              = 60
  evaluation_periods  = 1
  comparison_operator = "LessThanThreshold"
  threshold           = 1
  treat_missing_data  = "breaching"

  alarm_actions = [aws_sns_topic.website_health_alerts.arn]
  ok_actions    = [aws_sns_topic.website_health_alerts.arn]
}
