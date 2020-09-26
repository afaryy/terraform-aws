# terraform import aws_sns_topic.alarm_topic arn:aws:sns:ap-southeast-2:421117346104:alarms_topic

resource "aws_sns_topic" "alarms_topic" {
    name   = var.sns_name
    /*
    policy = jsonencode(
        {
            Id        = "__default_policy_ID"
            Statement = [
                {
                    Action    = [
                        "SNS:GetTopicAttributes",
                        "SNS:SetTopicAttributes",
                        "SNS:AddPermission",
                        "SNS:RemovePermission",
                        "SNS:DeleteTopic",
                        "SNS:Subscribe",
                        "SNS:ListSubscriptionsByTopic",
                        "SNS:Publish",
                        "SNS:Receive",
                    ]
                    Condition = {
                        StringEquals = {
                            AWS:SourceOwner = "421117346104"
                        }
                    }
                    Effect    = "Allow"
                    Principal = {
                        AWS = "*"
                    }
                    Resource  = "arn:aws:sns:ap-southeast-2:421117346104:alarms_topic"
                    Sid       = "__default_statement_ID"
                },
            ]
            Version   = "2008-10-17"
        }
    )
    tags   = {}
    */
}



