/* # Uncomment when testing weighted routing
resource "aws_route53_record" "green" {
    name           = "demo"
    set_identifier = "green"
    type           = "A"
    zone_id        = var.zone_id

    alias {
        evaluate_target_health = true
        name                   = var.elb_name_green
        zone_id                = var.elb_zoneid_green
    }

    weighted_routing_policy {
        weight = 80
    }
}
resource "aws_route53_record" "blue" {
    name           = "demo"
    set_identifier = "blue"
    type           = "A"
    zone_id        = var.zone_id

    alias {
        evaluate_target_health = true
        name                   = var.elb_name_blue
        zone_id                = var.elb_zoneid_blue
    }

    weighted_routing_policy {
        weight = 20
    }
}
*/

