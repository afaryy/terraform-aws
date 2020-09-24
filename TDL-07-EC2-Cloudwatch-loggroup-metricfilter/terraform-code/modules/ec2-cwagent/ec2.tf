resource "aws_instance" "instance" {
  ami                         = var.AMIS[var.aws_region]
  instance_type               = var.instance_type
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  subnet_id                   = var.subnet
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.role-instanceprofile.name

  user_data = data.template_file.shell-script.rendered

  tags = {
    Name = "${var.project_name}-Instance"
  }

  root_block_device {
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = "20"
  }
}