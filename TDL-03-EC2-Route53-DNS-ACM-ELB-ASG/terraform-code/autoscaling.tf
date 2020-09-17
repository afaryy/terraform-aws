
resource "aws_launch_configuration" "example-launchconfig" {
  name_prefix     = "${var.project_name}-launchconfig"
  image_id        = var.AMIS[var.AWS_REGION]
  instance_type   = "t2.micro"
  key_name        = "yvonne"
  security_groups = [aws_security_group.myinstance.id]
  user_data       = data.template_file.shell-script.rendered
  lifecycle {
    create_before_destroy = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "example-autoscaling" {
  name                      = "${var.project_name}-autoscaling"
  vpc_zone_identifier       = ["subnet-04709dce111382a62","subnet-00d8a496401ddc8de"]
  launch_configuration      = aws_launch_configuration.example-launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.my-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }
}

