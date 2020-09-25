resource "aws_cloudwatch_metric_alarm" "alarm" {
    actions_enabled           = true
    alarm_actions             = [aws_sns_topic.alarms_topic.arn]
    alarm_name                = var.alarm_name
    alarm_description         = "This metric monitors ec2 HTTP 404 ERROR"
    comparison_operator       = "GreaterThanThreshold"
    datapoints_to_alarm       = 1
    dimensions                = {}
    evaluation_periods        = 1
    insufficient_data_actions = []
    metric_name               = var.metric_name
    namespace                 = var.metric_namespace
    ok_actions                = []
    period                    = 60
    statistic                 = "Sum"
    tags                      = {}
    threshold                 = 0
    treat_missing_data        = "missing"
}

