# CW log groups
resource "aws_cloudwatch_log_group" "log_group" {
  for_each          = var.log_groups
  name              = "${var.project_name}-${each.key}"
  retention_in_days = each.value.retention_in_days
  kms_key_id        = aws_kms_key.kms_key.arn

  tags = {
    Environment = "test"
    Application = "web service"
  }
}

