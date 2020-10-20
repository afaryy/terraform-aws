# https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-cwl.html
resource "aws_iam_role" "flowlog_role" {
  name               = "${var.project_name}-vpc-flowlog-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
} 
EOF

  tags = {
    Name = "${var.project_name}-vpc-flowlog-role"
  }
}

resource "aws_iam_instance_profile" "role_instanceprofile" {
  name = "${var.project_name}-vpc-flowlog-instanceprofile"
  role = aws_iam_role.flowlog_role.name
}

resource "aws_iam_role_policy" "role-policy" {
  name   = "${var.project_name}-vpc-flowlog-role-policy"
  role   = aws_iam_role.flowlog_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}   
EOF

}