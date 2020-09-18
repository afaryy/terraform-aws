output "kms_key_arn" {
  value = aws_kms_key.kms_key.arn
}

output "log_groups" {
  description = "List of log groups"

  value = {
      for log in aws_cloudwatch_log_group.log_group :
      log.id => {
        name                     = log.name
        retention_in_days        = log.retention_in_days
        kms_key_id               = log.kms_key_id 
      }
  }
}