# Create an Route 53 record demo.dryovnne.net (A record) in ur domain and point to the VM public ip
  resource "aws_route53_record" "demo" {
  zone_id =  "Z0487567QK3UCA9HOK0T"
  name    = "demo"
  type    = "A"

  alias {
    name                   = aws_elb.my-elb.dns_name
    zone_id                = aws_elb.my-elb.zone_id
    evaluate_target_health = true
  }
}
