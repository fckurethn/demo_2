#!/bin/bash
sudo apt update -y
sudo apt install -y apache2
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>"  >  /var/www/html/index.html
sudo systemctl start httpd
