# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb
# https://stackoverflow.com/questions/34609095/cloudformation-in-create-stack-error-elb-cannot-be-attached-to-multiple-subnet

resource "aws_elb" "my-elb" {
  name            = "my-elb"
  subnets         = ["subnet-04709dce111382a62","subnet-00d8a496401ddc8de"]
  # availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]
  security_groups = [aws_security_group.elb-securitygroup.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:ap-southeast-2:421117346104:certificate/3699ca25-e7cd-4157-aef6-0a680a51652e"
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
    Name = "my-elb"
  }
}

