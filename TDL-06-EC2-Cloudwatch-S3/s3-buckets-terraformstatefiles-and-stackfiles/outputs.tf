output "terraform_state_bucket" {
  value = {
      bucket_name = aws_s3_bucket.terraform_state_bucket.id
      bucket_arn  = aws_s3_bucket.terraform_state_bucket.arn
  }
}

output "project_stack_bucket" {
    value = {
      bucket_name = aws_s3_bucket.project_stack_bucket.id
      bucket_arn  = aws_s3_bucket.project_stack_bucket.arn
  }
}
