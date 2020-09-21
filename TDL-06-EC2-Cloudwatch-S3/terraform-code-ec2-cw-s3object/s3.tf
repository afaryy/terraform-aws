resource "aws_s3_bucket_object" "object" {
  bucket = var.bucket_name
  key    = "config.json"
  source = "${path.module}/scripts/config.json"
}