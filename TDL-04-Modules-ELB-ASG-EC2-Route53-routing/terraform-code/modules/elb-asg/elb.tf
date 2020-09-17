# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb
# https://stackoverflow.com/questions/34609095/cloudformation-in-create-stack-error-elb-cannot-be-attached-to-multiple-subnet

resource "aws_elb" "my-elb" {
  name                  = "${var.project_name}-${var.stack_name}-elb"
  subnets               = var.subnets
  # availability_zones  = ["ap-southeast-2a", "ap-southeast-2b"]
  security_groups       = [aws_security_group.elb-securitygroup.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = var.ssl_certificate_id
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
  tags = {
    Name = "${var.project_name}-${var.stack_name}-elb"
  }
}

