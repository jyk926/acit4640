declare network_name="sys_net_prov"
declare network_address="192.168.1.0"
declare cidr_bits="24"
declare rule_name1="ssh_wp"
declare rule_name2="http_wp"
declare rule_name3="ssl_wp"


vboxmanage natnetwork add \
            --netname ${network_name} \
            --network "${network_address}/${cidr_bits}" \
            --dhcp off 

VBoxManage natnetwork modify --netname ${network_name} --port-forward-4 "ssh_wp:tcp:[]:50022:[192.168.254.10]:22"
VBoxManage natnetwork modify --netname ${network_name} --port-forward-4 "http_wp:tcp:[]:50080:[192.168.254.10]:80"
VBoxManage natnetwork modify --netname ${network_name} --port-forward-4 "ssl_wp:tcp:[]:50443:[192.168.254.10]:443"
VBoxManage list natnetworks
