
#!/bin/bash
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><body>Availability Zone of this instance: " > index.html
curl http://169.254.169.254/latest/meta-data/placement/availability-zone >> index.html
echo "</body></html>" >> index.html