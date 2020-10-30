# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log
resource "aws_flow_log" "vpc_flow_log" {
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.log_group.arn
  iam_role_arn         = aws_iam_role.flowlog_role.arn
  traffic_type         = var.traffic_type
  vpc_id               = var.vpc_id
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.vpc_flowlog_log_group_name
  retention_in_days = 30
}
# valid retention_in_days : [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]
