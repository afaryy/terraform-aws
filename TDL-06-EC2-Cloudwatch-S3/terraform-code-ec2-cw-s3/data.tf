data "template_file" "shell-script" {
  template = file("${path.module}/scripts/install_apache_cwagent.sh")

  vars = {
    bucket_name = "${var.bucket_name}"
  }
}