resource "aws_iam_role" "ec2-role" {
  name               = "${var.project_name}-ec2-s3-cwlogs-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "InstanceS3CWRole"
    }
  ]
}
EOF

  tags = {
    Name = "${var.project_name}-ec2-s3-cwlogs-role"
  }
}

resource "aws_iam_instance_profile" "role-instanceprofile" {
  name = "${var.project_name}-ec2-cwlogs-role-instanceprofile"
  role = aws_iam_role.ec2-role.name
}

resource "aws_iam_role_policy" "role-policy" {
  name = "${var.project_name}-ec2-s3-cwlogs-role-policy"
  role = aws_iam_role.ec2-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:DescribeVolumes",
                "ec2:DescribeTags",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
              "${data.aws_s3_bucket.bucket.arn}/",
              "${data.aws_s3_bucket.bucket.arn}/*"
            ]
        }
    ]
}
EOF
}
