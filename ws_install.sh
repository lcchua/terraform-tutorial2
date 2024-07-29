# To bootstrap the installation of httpd and docker upon creation of EC2 instance

#!/bin/bash
echo "Installing the httpd and docker packages to the EC2 server..." > /tmp/ec2-user.txt

<<COMMENT_OUT
yum update -y
yum install httpd -y
yum install docker -y
systemctl start httpd
systemctl enable httpd
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
reboot
COMMENT_OUT