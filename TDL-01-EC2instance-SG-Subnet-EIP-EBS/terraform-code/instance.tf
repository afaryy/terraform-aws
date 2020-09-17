
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "todo_instance1_sg" {
  name        = "todo_instance1_sg"
  description = "Allow inbound ssh traffic from own ip"
  vpc_id      = "vpc-02ec2836691642ace"

  ingress {
    description = "Inbound SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "180.150.39.3/32", 
      "110.147.203.93/32"
     ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "todo_instance1_sg"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "main-public-1" {
  vpc_id                  = "vpc-02ec2836691642ace"
  cidr_block              = "10.128.1.0/24"
  map_public_ip_on_launch = "true" # Specify true to indicate that instances launched into the subnet should be assigned a public IP address
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "main-public-1"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "todo_instance1" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # the public SSH key
  # aws ec2 create-key-pair --key-name mykeypair --query 'KeyMaterial' --output text > mykeypair.pem
  key_name = "mykeypair"

  vpc_security_group_ids = [
    aws_security_group.todo_instance1_sg.id
  ]

  tags = {
    Name = "demo-1"
    Owner= "YaoYY"
  }

  # HVM root device_name: /dev/sda1 or /dev/xvda
  root_block_device {
    delete_on_termination = false
    volume_type = "gp2"
    volume_size = "20"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "todo_instance1_eip" {
  instance = aws_instance.todo_instance1.id
  vpc      = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume
resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "${var.AWS_REGION}a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "extra volume data"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment
# The device name to expose to the instance (for example, /dev/sdh or xvdh). 
# See Device Naming on Linux Instances and Device Naming on Windows Instances for more information.
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html#available-ec2-device-names
resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh" 
  volume_id   = aws_ebs_volume.ebs-volume-1.id
  instance_id = aws_instance.todo_instance1.id
}

