# log group name changed  -> log group will be replaced; key name changed -> key will be updated.

project_name = "TDL-05" # cloudwatch-log-group-persistent

aws_region = "ap-southeast-2"

log_groups = {
    apache-access-log = {
        retention_in_days = 14 # Valid values are: [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]
    }
    apache-error-log = {
        retention_in_days = 14
    }
}

