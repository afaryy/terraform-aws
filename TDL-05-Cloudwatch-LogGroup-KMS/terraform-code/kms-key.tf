# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html
resource "aws_kms_key" "kms_key" {
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
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "logs.ap-southeast-2.amazonaws.com"
                    },
                    "Action": [
                        "kms:Encrypt*",
                        "kms:Decrypt*",
                        "kms:ReEncrypt*",
                        "kms:GenerateDataKey*",
                        "kms:Describe*"
                    ],
                    "Resource": "*",
                    "Condition": {
                        "ArnLike": {
                            "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:ap-southeast-2:421117346104:*"
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