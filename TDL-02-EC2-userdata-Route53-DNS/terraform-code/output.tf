output "instance_ip" {
  description = "Instance EIP"
  value = aws_eip.todo_instance_eip.public_ip
}
