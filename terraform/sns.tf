resource "aws_sns_topic" "website_health_alerts" {
  name = "website-health-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.website_health_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
