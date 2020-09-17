# test failover routing
resource "aws_route53_record" "green" {
    name           = "demo"
    set_identifier = "green"
    #ttl            = 0
    type           = "A"
    zone_id        = var.zone_id

    alias {
        evaluate_target_health = true
        name                   = var.elb_name_green
        zone_id                = var.elb_zoneid_green
    }

    failover_routing_policy {
        type = "PRIMARY"
    }
}
resource "aws_route53_record" "blue" {
    name           = "demo"
    set_identifier = "blue"
    #ttl            = 0
    type           = "A"
    zone_id        = var.zone_id

    alias {
        evaluate_target_health = true
        name                   = var.elb_name_blue
        zone_id                = var.elb_zoneid_blue
    }

    failover_routing_policy {
        type = "SECONDARY"
    }
}