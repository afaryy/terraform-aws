resource "aws_kms_key" "kms-key" {
    description              = "${var.project_name}-KMS key"
    enable_key_rotation      = false
    is_enabled               = true
    key_usage                = "ENCRYPT_DECRYPT"
    policy                   = jsonencode(
        {
            "Version": "2012-10-17",
            "Id": "key-default-1",
            "Statement": [
                {
                    "Sid": "Enable IAM User Permissions",
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": "arn:aws:iam::421117346104:root"
                    },
                    "Action": "kms:*",
                    "Resource": "*"
                },
                {
                    "Sid": "Allow service-linked role use of the CMK",
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": "arn:aws:iam::421117346104:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
                    },
                    "Action": [
                        "kms:Encrypt",
                        "kms:Decrypt",
                        "kms:ReEncrypt*",
                        "kms:GenerateDataKey*",
                        "kms:DescribeKey"
                    ],
                    "Resource": "*"
                },
                {
                    "Sid": "Allow attachment of persistent resources",
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": "arn:aws:iam::421117346104:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
                    },
                    "Action": "kms:CreateGrant",
                    "Resource": "*",
                    "Condition": {
                        "Bool": {
                            "kms:GrantIsForAWSResource": "true"
                        }
                    }
                }
            ]
        }
    )
    tags = {
      Name = "${var.project_name}-kms-key"
    }
}