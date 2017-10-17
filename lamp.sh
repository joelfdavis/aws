#make sure you are root
if [[ `whoami` != "root" ]];then
 echo "ERROR: you are `whoami` .. not root.."
 exit
else
 echo "OK you are `whoami` ... continuing..."
fi
#set -o vi
#run latest updates
yum -y update
#NOTE: may need to reboot if kernel updated
#reboot
#install the rpms....
yum -y install httpd php mariadb mariadb-server
#restart services
service httpd restart
chkconfig httpd on
systemctl start mariadb
systemctl enable mariadb
#secure mysql
#mysql_secure_installation
#config apache user/dirs
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
#create test file
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
#make sure file is created
cat /var/www/html/phpinfo.php
if [[ -f /var/www/html/phpinfo.php ]];then
 echo "OK: test file created"
else
 echo "ERROR: test file not created"
fi
