# Overview

* [Terraform](https://www.terraform.io/) is an Infrastructure as Code tool to provision and manage any cloud, infrastructure, or service.
* These files are about my solutions to provision, manage and automate multiple [AWS services](https://aws.amazon.com/) through [Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) , Bash, [Python](https://www.python.org/downloads/) scripts.



# Pre-Requisites
* [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) 
* [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [Install Make](https://www.gnu.org/software/make/manual/html_node/index.html#toc-Overview-of-make)
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Python](https://www.python.org/downloads/)
* [Boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html)


# Content

Code Directory | Decription | AWS services  
------------ | ------------- | ------------- 
[TDL-01-EC2instance-SG-Subnet-EIP-EBS](./TDL-01-EC2instance-SG-Subnet-EIP-EBS/terraform-code/) | Create a EC2 instance in public subnet | EC2, Security Group, Subnet, EIP, EBS 
[TDL-02-EC2-userdata-Route53-DNS](./TDL-02-EC2-userdata-Route53-DNS/terraform-code/) | Launch an EC2 instance in public subnet, install Apache HTTP server using below user data script, create Security group for it.<br> From jumpbox SSH to the VM and check httpd.<br>Create an Route 53 record in your domain and point to the VM public ip.<br>Access the web server using DNS name. | EC2, Route53, DNS 
[TDL-03-EC2-Route53-DNS-ACM-ELB-ASG](./TDL-03-EC2-Route53-DNS-ACM-ELB-ASG/terraform-code/) | Create an ACM cert for your domain from AWS Console.<br>Create ELB/ASG, ELB listener: tcp/443 with domain name, backend: tcp/80 to the vms created by ASG.<br>Update R53 record.<br>Access web server by dsn name, which shows differnt ap-southeast-2a/b/c when u refresh the url. | EC2, Route53, DNS, ACM, ELB, ASG 
[TDL-04-Modules-ELB-ASG-EC2-Route53-routing](./TDL-04-Modules-ELB-ASG-EC2-Route53-routing/terraform-code) | Create your terraform moudule based on To-do-list-03.<br>Update HTTP index.html with stackname in userdata.<br>Encrypt root disk using ur own KMS key.<br>Input Variables: ACM certificate ARN, DNS name, KMS Key ARM, Subnets, stack_name etc.<br>Create 2 ELB/ASG/EC2 by calling your module.<br>Route 53 active-active failover test.<br>Route 53 active-passive failover test.<br>Route 53 weighted routing test. | ELB, ASG, ACM, DNS, Route53 routing 
[DA-iac01-EC2-S3](./DA-iac01-EC2-S3/) | Create an EC2 instance and a S3 Bucket.<br>The EC2 instance needs to be accessible through SSH.<br>The EC2 instance needs to have permission to access the S3 bucket. | EC2, S3, IAM 
[DA-iac02-VPC-Subnet-IGW-NGW-RouteTables](./DA-iac02-VPC-Subnet-IGW-NGW-RouteTables/) |  Create VPC: /16 CIDR of your choice in the 10.0.X.X range,<br> 4 /24 Subnets(2 publics and privates),<br>Internet GW attached to your VPC, 1 NAT GW,<br>Routing tables for the subnets be able to communicate witht he internet. | VPC, Subnet, Internet Gateway, NAT Gateway. Route Tables exercises/c04-iac02/README.md)
[DA-iac03-VPC-ChangeInputVariables](./DA-iac03-VPC-ChangeInputVariables/) |  Modify CIDR and Name values from your input variables. <br> Execute the terraform plan command to check the changes. | VPC, Subnet 
[DA-iac04-ALB-ASG-SG-CW-Route53](./DA-iac04-ALB-ASG-SG-CW-Route53/) |  ALB distributes the load for an ASG group of EC2 instances.<br>ASG have 2 scaling policies(one to increase and another to decrease the number of hosts).<br>Security Groups so the ALB can be accessed from the internet.<br>Create Route53 record associated with ALB. | Application Load Balancer, Autoscaling Group, Cloudwatch Alarm, Security Group, Route53 Record 
[TDL-05-Cloudwatch-LogGroup-KMS](./TDL-05-Cloudwatch-LogGroup-KMS) | Create 2 CloudWatch log groups with KMS keys. | Cloudwatch, KMS 
[TDL-06-EC2-Cloudwatch-S3](./TDL-06-EC2-Cloudwatch-S3) | Based on TDL-05, upload CW agnet confgiuration files in S3 bucket, <br>update instance profile so EC2 is able to put logs to CW log group and download confgiuration file from S3 bucket, <br>Update userdata script to install and configure CW agent automatically. <br>Access web page, and check whether access logs have been shipped to CW log groups. | Cloudwatch, EC2, S3 
[TDL-07-EC2-Cloudwatch-loggroup-metricfilter](./TDL-07-EC2-Cloudwatch-loggroup-metricfilter) | Based on code TDL-06,  generate 404 log message to CW log group apache-access-log, create metric filter (HTTP 404 errors) and metric.| Cloudwatch, EC2, S3 
[TDL-08-EC2-Cloudwatch-alarm-SNS](./TDL-08-EC2-Cloudwatch-alarm-SNS) | Based on code TDL-07, Create one CW alarm based on CW metrics, once alarm is triggered, send notificaiton to your email .| Cloudwatch, SNS, EC2, S3 
[TDL-09-shell-EC2](./TDL-09-shell-EC2) | Use Shell script to deploy instances with different ostypes, intance types, and add tages like agedtime.| Shell, EC2
[TDL-10-shell-EC2-EBS](./TDL-10-shell-EC2-EBS) | Use Shell script to deploy instances with different ostypes, intance types, datadisk sizes and add tages like agedtime. Data disk: mount point /data. | Shell, EC2, EBS 
[TDL11-Terminate_Instances<br>_with_snapshots](./TDL11-Terminate_Instances_with_snapshots) | Use python script to teminate aged instances with snapshots (Exclude Boot Volume) created for EBS before teminating. | Python, EC2, EBS, Snapshot 
[TDL12-Python-Lambda-Cloudwatch](./TDL12-Python-Lambda-Cloudwatch) | Use Terraform to deploy lambda function terminate_aged_instances_with_snapshots.<br> Create IAM role for lambda function<br>CloudWatch event rule to triger the lambda function every 5 minutes. | Python, Lambda, EC2, EBS, Snapshot, Cloudwatch 
[TDL13-VPC-Flowlog-Cloudwatch](./TDL13-VPC-Flowlog-Cloudwatch) | Terraform template to create VPC Flowlog for VPC. | VPC Flowlog, IAM, Cloudwatch 
[TTDL14-Python-VPCLoggroup-CW-Loginsight](./TDL14-Python-VPCLoggroup-CW-Loginsight) | Based on TDL-06 and TDL-13, install and configure CW agent on EC2 based on config file in S3, Create VPC Flowlog for VPC. Use Python Script to automated query CW logs against VPC Flowlog group and apache-access-log group. | Python, CW logs insight, IAM, EC2, VPC Flowlog, Cloudwatch Agent


# Author

## Yingying(Yvonne) Yao

- Linkedin: [https://www.linkedin.com/in/yvonneyao/](https://www.linkedin.com/in/yvonneyao/)
- Github: [https://github.com/afaryy](https://github.com/afaryy)
- Member: [DevOps Academy](https://github.com/devopsacademyau), [DevopsGirls](devopsgirls.slack.com)

