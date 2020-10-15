resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-lambda-ec2-cw-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Sid": "LambdaEC2CWRole"
    }
  ]
}
EOF

  tags = {
    Name = "${var.project_name}-lambda-ec2-cw-role"
  }
}

resource "aws_iam_instance_profile" "role_instanceprofile" {
  name = "${var.project_name}-lambda-ec2-cw-instanceprofile"
  role = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy" "role-policy" {
  name = "${var.project_name}-lambda-ec2-cw-role-policy"
  role = aws_iam_role.lambda_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeTags",
                "ec2:DescribeVolumesModifications",
                "ec2:ModifyInstanceAttribute",
                "ec2:DescribeSnapshots",
                "ec2:CreateSnapshots",
                "ec2:CreateSnapshot",
                "ec2:Start*",
                "ec2:Stop*",
                "ec2:Terminate*",
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*"
        }
    ]
}
EOF

}