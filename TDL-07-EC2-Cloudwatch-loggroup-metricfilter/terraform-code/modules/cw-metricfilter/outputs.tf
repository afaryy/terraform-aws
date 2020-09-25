output "metric_filter" {
  value = {
    filter_name            = aws_cloudwatch_log_metric_filter.filter.name
    filter_parttern        = aws_cloudwatch_log_metric_filter.filter.pattern
    metric_name            = aws_cloudwatch_log_metric_filter.filter.metric_transformation[0].name
    metric_namespace       = aws_cloudwatch_log_metric_filter.filter.metric_transformation[0].namespace
    metric_value           = aws_cloudwatch_log_metric_filter.filter.metric_transformation[0].value
    default_value          = aws_cloudwatch_log_metric_filter.filter.metric_transformation[0].default_value
  }
}
