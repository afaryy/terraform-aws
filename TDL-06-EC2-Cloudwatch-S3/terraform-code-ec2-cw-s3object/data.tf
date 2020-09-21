data "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

data "template_file" "shell-script" {
  template = file("${path.module}/scripts/install_apache_cwagent.sh")

  vars = {
    bucket_name = "${var.bucket_name}" #aws_s3_bucket_object.bootstrap_script.body
  }
}

