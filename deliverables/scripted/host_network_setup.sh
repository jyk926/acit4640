declare network_name="sys_net_prov"
declare network_address="192.168.1.0"
declare cidr_bits="24"
declare rule_name1="ssh_wp"
declare rule_name2="http_wp"
declare rule_name3="ssl_wp"
declare protocol="tcp"
declare global_ip =""
declare local_ip ="192.168.1.5"

vboxmanage natnetwork add \
            --netname ${network_name} \
            --network "${network_address}/${cidr_bits}" \
            --dhcp off 

vboxmanage natnetwork modify \
            --netname ${network_name} 
            --port-forward-4 "${rule_name1}:${protocol}:[${global_ip}]:'50022':[${local_ip}]:'22'"
vboxmanage natnetwork modify \
            --netname ${network_name} 
            --port-forward-4 "${rule_name2}:${protocol}:[${global_ip}]:'50080':[${local_ip}]:'80'"
vboxmanage natnetwork modify \
            --netname ${network_name} 
            --port-forward-4 "${rule_name3}:${protocol}:[${global_ip}]:'50443':[${local_ip}]:443"
