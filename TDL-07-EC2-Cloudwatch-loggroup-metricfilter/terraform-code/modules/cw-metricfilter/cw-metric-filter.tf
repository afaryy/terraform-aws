resource "aws_cloudwatch_log_metric_filter" "filter" {
  name            = "${var.project_name}-${var.filter_name}"
  pattern         = var.filter_pattern
  log_group_name  = var.log_group_name

  metric_transformation {
    name          = "${var.project_name}-${var.metric_name}"
    namespace     = var.metric_namespace
    value         = var.metric_value
    default_value = var.metric_default_value
  }
}
