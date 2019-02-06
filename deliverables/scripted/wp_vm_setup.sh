vboxmanage () { VBoxManage.exe "$@"; }
# get the absolute path of the current script 
declare script_path="$(python -c "import os; print(os.path.realpath('$0'))")"

# get the path of its enclosing directory us this to setup relative paths
declare script_dir="$(dirname ${script_path})"

# Cludge to get the path of the directory where the vbox file is stored: creates file adjacent to vbox file
# vboxmanage showvminfo displays line with the path to the config file -> grep "Config file returns it
# the extended regex `(/[^/]+)+' matches everything that is a path i.e. / followed  by anthing not / 

# You will need to change the VM name to match one of your VM's
declare vm_name="test"

declare vm_info="$(vboxmanage showvminfo "${vm_name}")"
declare vm_conf_line="$(echo "${vm_info}" | grep "Config file")"
declare vm_conf_file="$( echo "${vm_conf_line}" | grep -oE '(/[^/]+)+')"
declare vm_directory="$(dirname "${vm_conf_file}")"

echo "${vm_directory}"

declare cidr_bits="24"
declare network_name="sys_net_prov"
declare global_ip=[]
declare local_ip="192.168.254.10"
declare protocol="tcp"
declare global_port="80"
declare local_port="50080"
vboxmanage natnetwork add \
            --netname ${network_name} \
            --network "192.168.254.0/${cidr_bits}" \
            --dhcp off 

vboxmanage natnetwork modify \
            --netname ${network_name} 
            --port-forward-4 "rule1:${protocol}:[${global_ip}]:${global_port}:[${local_ip}]:${local_port}"

vboxmanage list natnetworks
vboxmanage natnetwork remove --netname ${network_name}
vboxmanage natnetwork remove --netname ${network_name}

vboxmanage createhd --filename ${vm_folder}/${vm_name}.vdi \
                    --size ${size_in_mb} -variant Standard
vboxmanage storagectl ${vm_name} --name "controller1" --add "ide" --bootable on //ide
vboxmanage storagectl ${vm_name} --name "controller2" --add "sata" --bootable on //sata
vboxmanage storageattach ${vm_name} \
            --storagectl ${ctrlr_name} \ 
            --port ${port_num} \
            --device ${devic_num} \
            --type dvddrive \
            --medium ${iso_file_path}

vboxmanage modifyvm ${vm_name}\
            --groups "${group_name}"\
            --ostype "RedHat_64"\
            --cpus 1\
            --hwvirtex on\
            --nestedpaging on\
            --largepages on\
            --firmware bios\
            --nic1 natnetwork\
            --nat-network1 "${network_name}"\
            --cableconnected1 on\
            --audio none\
            --boot1 disk\
            --boot2 dvd\
            --boot3 none\
            --boot4 none\
            --memory "${memory_mb}"

vboxmanage startvm ${vm_name} --type gui
