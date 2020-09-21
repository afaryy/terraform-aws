
#!/bin/bash
# install apache on EC2 instance
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
echo "<html><body>Test Cloudwatch Agent on Instance: $(hostname -f)</body></html>"  > /var/www/html/index.html

# install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# install the agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm 
rpm -U ./amazon-cloudwatch-agent.rpm

# create some missing files
mkdir -p /usr/share/collectd
touch /usr/share/collectd/types.db

# Download the config file from the bucket
aws s3 cp s3://${bucket_name}/config.json /tmp/config.json
cp /tmp/config.json  /opt/aws/amazon-cloudwatch-agent/bin/config.json

# start the cloudwatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json



