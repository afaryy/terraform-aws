data "aws_vpc" "da-c02-vpc" {
  #id = "${var.vpc_id}"
  id = "vpc-02ec2836691642ace"
}


data "template_file" "shell-script" {
  template = file("${path.module}/scripts/install_apache.sh")
}