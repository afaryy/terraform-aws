output "alarm" {
  value = {
    alarm_arn             = aws_cloudwatch_metric_alarm.alarm.arn
    alarm_actions         = aws_cloudwatch_metric_alarm.alarm.alarm_actions
    comparison_operator   = aws_cloudwatch_metric_alarm.alarm.comparison_operator
    threshold             = aws_cloudwatch_metric_alarm.alarm.threshold
    period                = aws_cloudwatch_metric_alarm.alarm.period
    datapoints_to_alarm   = aws_cloudwatch_metric_alarm.alarm.datapoints_to_alarm
    evaluation_periods    = aws_cloudwatch_metric_alarm.alarm.evaluation_periods
  }
}

