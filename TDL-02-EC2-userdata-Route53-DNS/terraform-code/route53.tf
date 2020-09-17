# Create an Route 53 record demo.dryovnne.net (A record) in ur domain and point to the VM public ip
resource "aws_route53_record" "demo" {
  zone_id = "Z0487567QK3UCA9HOK0T"
  name    = "demo"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.todo_instance_eip.public_ip]
}


