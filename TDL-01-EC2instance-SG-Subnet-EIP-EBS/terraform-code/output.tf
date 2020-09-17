output "instance_ip" {
  description = "Instance EIP"
  value = aws_eip.todo_instance1_eip.public_ip
}
