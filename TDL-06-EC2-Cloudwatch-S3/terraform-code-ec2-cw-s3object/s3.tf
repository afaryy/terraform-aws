resource "aws_s3_bucket_object" "object" {
  bucket = var.bucket_name
  key    = "${var.prefix}config.json"
  source = "${path.module}/upload/config.json"
}