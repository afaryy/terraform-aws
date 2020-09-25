resource "aws_security_group" "instance_sg" {
  name        = "${var.project_name}-instance-sg"
  description = "Allow http traffic and all egress traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Inbound HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-instance-sg"
  }
}