
data "template_file" "shell-script" {
  template = file("${path.module}/scripts/install_apache.sh")
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "todo_instance_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow inbound ssh traffic from own ip"
  vpc_id      = "vpc-02ec2836691642ace"

  ingress {
    description = "Inbound SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "180.150.39.3/32", #mentor
      "110.147.203.93/32" #me
     ]
  }

  ingress {
    description = "Inbound HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
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
    Name = "${var.project_name}-sg"
  }
}

resource "aws_security_group_rule" "allow_jumpbox_access" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "sg-01aac9b3d4540fb5f"
  security_group_id        = aws_security_group.todo_instance_sg.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
#resource "aws_subnet" "main-public-1" {
  #vpc_id                  = "vpc-02ec2836691642ace"
  #cidr_block              = "10.128.1.0/24"
 #map_public_ip_on_launch = "true" # Specify true to indicate that instances launched into the subnet should be assigned a public IP address
  #availability_zone       = "${var.AWS_REGION}a"

  #tags = {
    #Name = "${var.project_name}-public"
 # }
#}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "todo_instance" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "subnet-04709dce111382a62"  #aws_subnet.main-public-1.id

  # the public SSH key
  key_name = "ericho"

  vpc_security_group_ids = [
    aws_security_group.todo_instance_sg.id
  ]

  tags = {
    Name = "${var.project_name}"
    Owner= "YaoYY"
  }

  # HVM root device_name: /dev/sda1 or /dev/xvda
  root_block_device {
    delete_on_termination = false
    volume_type = "gp2"
    volume_size = "20"
  }

  # user data
  user_data = data.template_file.shell-script.rendered
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "todo_instance_eip" {
  instance = aws_instance.todo_instance.id
  vpc      = true
}



