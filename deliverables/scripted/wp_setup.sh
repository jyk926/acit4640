#systemctl restart network #restart network

usermod -a -G wheel admin #Add user Admin to the group wheel

cd /home/admin #change current directory to the admin

#Download Public key for ssh
mkdir .ssh/ #create ssh folder
cd .ssh/ #change current directory to the ssh folder
yum install wget #install wget
wget --user student --password w1nt3r2019 https://4640.acit.site/code/ssh_setup/acit_admin_id_rsa.pub #download public key
mv acit_admin_id_rsa.pub authorized_keys #Rename file anme to the authorized_key

#Disable SELinux
setenforce 0
sed -r -i 's/SELINUX=(enforcing|disabled)/SELINUX=permissive/' /etc/selinux/config

#Install Packages
yum install @core epel-release vim git tcpdump nmap-ncat curl #download all the require package 
yum update #update

#Set up Firewall
sudo firewall-cmd --zone=public --add-port=22/tcp --permanent #port 22
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent #port 80
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent #port 443
sudo firewall-cmd --zone=public --list-all #Show open host ports

#nginx Setup
yum install nginx #install
sudo systemctl start nginx #start nginx
sudo systemctl enable nginx #enable nginx
sudo systemctl status nginx #verifiy status

#MariaDB setup
yum install mariadb-server #Install mariadb-server
yum install mariadb #Install mariadb
sudo systemctl start mariadb #start mariadb
mysql -u root < mariadb_security_config.sql #configuration script
sudo systemctl enable mariadb #enable mariadb

#PHP setup
yum install php #install php
yum install php-mysql #install php-mysql
yum install php-fpm #install php-fpm
mv -f php.ini /etc/php.ini #move php.ini to the directory
mv -f www.conf /etc/php-fpm.d/www.conf #move www.conf to the directory
sudo systemctl start php-fpm #start php-fpm
sudo systemctl enable php-fpm #enable php-fpm
mv -f info.php /usr/share/nginx/html/info.php #move info.php to the directory 
sudo systemctl restart nginx #restart nginx

#WordPress Setup
mysql - u root < wp_mariadb_config.sql #excute wp maria db script
mysql -u root -e "SELECT user FROM mysql.user;" #verify user creation
mysql -u root -e "SHOW DATABASES;" #verify db creation

#Wordpress source setup
wget https://wordpress.org/latest.tar.gz #download wordpress
tar xzvf latest.tar.gz #untar
cp wordpress/wp-config-sample.php wordpress/wp-config.php #create wordpress configuration
mv -f wp-config.php wordpress/wp-config.php #update config
rsync -avP wordpress/ /usr/share/nginx/html/ #resync
mkdir /usr/share/nginx/html/wp-content/uploads #create d directory
sudo chown -R admin:nginx /usr/share/nginx/html/* #set the permission
sudo systemctl restart nginx #restart nginx