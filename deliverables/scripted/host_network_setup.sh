declare network_name="sys_net_prov" #Name of network
declare network_address="192.168.1.0" #Address of network
declare cidr_bits="24" #CIDR bits for network address
declare rule_name1="ssh_wp" #SSH forwarding rule
declare rule_name2="http_wp" #HTTP forwarding rule
declare rule_name3="ssl_wp" #SSL forwarding rule

#Configure NAT network
vboxmanage natnetwork add \
            --netname ${network_name} \
            --network "${network_address}/${cidr_bits}" \
            --dhcp off 

#IP forwarding rules
#Add ssh forwarding rules
VBoxManage natnetwork modify \
            --netname ${network_name} \
            --port-forward-4 "ssh_wp:tcp:[]:50022:[192.168.254.10]:22"
#Add http forwarding rules
VBoxManage natnetwork modify \
            --netname ${network_name} \
            --port-forward-4 "http_wp:tcp:[]:50080:[192.168.254.10]:80"
#Add ssl forwarding rules
VBoxManage natnetwork modify \
            --netname ${network_name} \
            --port-forward-4 "ssl_wp:tcp:[]:50443:[192.168.254.10]:443"

#Display NATnetwork setup
VBoxManage list natnetworks
