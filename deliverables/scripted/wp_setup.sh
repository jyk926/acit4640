sudo su
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
firewall-cmd --zone=public --add-port=22/tcp --permanent #port 22
firewall-cmd --zone=public --add-port=80/tcp --permanent #port 80
firewall-cmd --zone=public --add-port=443/tcp --permanent #port 443
firewall-cmd --zone=public --list-all #Show open host ports

#nginx Setup
yum install nginx #install
systemctl start nginx #start nginx
systemctl enable nginx #enable nginx
systemctl status nginx #verifiy status