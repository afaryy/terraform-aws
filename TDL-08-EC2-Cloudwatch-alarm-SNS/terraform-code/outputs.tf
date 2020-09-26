output "instance" {
  value = module.ec2-cwagent.instance
}


output "metric_filter" {
  value = module.filter.metric_filter
}

/*
output "metric_filter" {
  value = {
    filter_name            = module.filter.metric_filter.filter_name
    filter_parttern        = module.filter.metric_filter.filter_pattern
    metric_name            = module.filter.metric_filter.metric_name
    metric_namespace       = module.filter.metric_filter.metric_namespace
    metric_value           = module.filter.metric_filter.metric_value
    default_value          = module.filter.metric_filter.default_value
  }
}
*/

output "alarm" {
  value = module.alarm.alarm
}