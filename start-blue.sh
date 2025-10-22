#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
echo "<h1>Blue Environment</h1>" > /var/www/html/index.html
systemctl start httpd
