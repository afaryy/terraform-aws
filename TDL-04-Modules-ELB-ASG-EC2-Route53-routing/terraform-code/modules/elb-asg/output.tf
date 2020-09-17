output "elb_name" {
  value = aws_elb.my-elb.dns_name
}

output "elb_zoneid" {
  value = aws_elb.my-elb.zone_id
}