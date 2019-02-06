declare network_name="sys_net_prov"
declare vm_name="test"
declare vm_folder="/Users/Min/VirtualBox VMs/test"
declare size_in_mb=3600
declare ctrl_type1='sata'
declare ctrl_type2='ide'
declare ctrlr_name1='satactrl'
declare ctrlr_name2='idectrl'
declare memory_mb=1280

VBoxManage createvm --name ${vm_name} --register

VBoxManage createhd --filename "/Users/Min/VirtualBox VMs/test"/${vm_name}.vdi \
                    --size ${size_in_mb} -variant Standard

VBoxManage storagectl ${vm_name} --name ${ctrlr_name1} --add ${ctrl_type1} --bootable on
VBoxManage storagectl ${vm_name} --name ${ctrlr_name2} --add ${ctrl_type2} --bootable on

VBoxManage storageattach ${vm_name} \
            --storagectl ${ctrlr_name1} \
            --port 00 \
            --device 00 \
            --type dvddrive \
            --medium '/Users/Min/VirtualBox VMs/CentOS-7-x86_64-Minimal-1810.iso'

VBoxManage storageattach ${vm_name} \
            --storagectl ${ctrlr_name2} \
            --port 01 \
            --device 01 \
            --type dvddrive \
            --medium "/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso"

VBoxManage storageattach ${vm_name} \
            --storagectl ${ctrlr_name2} \
            --port 01 \
            --device 01 \
            --type hdd \
            --medium "/Users/Min/VirtualBox VMs/test"/${vm_name}.vdi \
            --nonrotational on

VBoxManage modifyvm ${vm_name}\
            --groups ""\
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
            --memory ${memory_mb}

VBoxManage startvm ${vm_name} --type gui