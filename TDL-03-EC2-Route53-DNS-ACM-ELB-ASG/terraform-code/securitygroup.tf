#  ELB listener: tcp/443 with domain name demo.dryonne.net backend: tcp/80 to the vms created by ASG

resource "aws_security_group" "myinstance" {
  name        = "${var.project_name}-instance-sg"
  description = "security group for my instance"
  vpc_id      = "vpc-02ec2836691642ace"

  ingress {
    description = "Inbound SSH from Jumpbox"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["sg-01aac9b3d4540fb5f"]
  }

  ingress {
    description = "Inbound 80 from ELB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb-securitygroup.id]
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

resource "aws_security_group" "elb-securitygroup" {
  vpc_id      = data.aws_vpc.da-c02-vpc.id
  name        = "${var.project_name}-elb-sg"
  description = "security group for load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-elb-sg"
  }
}

