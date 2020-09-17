#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
resource "aws_launch_template" "template" {
  name            = "${var.project_name}-${var.stack_name}-template"
  image_id        = var.AMIS[var.AWS_REGION]
  instance_type   = "t2.micro"
  key_name        = "ericho"
  vpc_security_group_ids = [aws_security_group.myinstance.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-${var.stack_name}-instance"
    }
  }

  monitoring {
    enabled = true
  }

  #network_interfaces {
    #associate_public_ip_address = false
    #delete_on_termination       = true
    #security_groups             = [aws_security_group.myinstance.id]
  #}

  block_device_mappings {
    device_name = "/dev/xvda" #"/dev/sda1" 

    ebs {
      delete_on_termination = false
      volume_type = "gp2"
      volume_size = "20"
      encrypted   = true
      kms_key_id  = var.kms_key_arn
    }
  }

  #user_data = filebase64("${path.module}/example.sh")
  user_data  = base64encode(data.template_file.shell-script.rendered)

  lifecycle {
    create_before_destroy = true
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "example-autoscaling" {
  name                      = "${var.project_name}-${var.stack_name}-autoscaling"
  vpc_zone_identifier       = var.subnets
  #launch_configuration      = aws_launch_configuration.example-launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.my-elb.name]
  force_delete              = true

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.stack_name}-autoscaling"
    propagate_at_launch = true
  }
}

