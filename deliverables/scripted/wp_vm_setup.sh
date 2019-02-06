#Declare variables
declare network_name="sys_net_prov"
declare vm_name="test"
declare size_in_mb=3600
declare ctrlr_name1="ctrl1"
declare ctrlr_name2="ctrl2"
declare group_name=""
declare memory_mb=1280

vboxmanage createvm --name ${vm_name} --register

vboxmanage createhd --filename "/Users/Min/VirtualBox VMs/"/${vm_name}.vdi \
                    --size ${size_in_mb} -variant Standard

vboxmanage storagectl ${vm_name} --name ${ctrlr_name1} --add "sata" --bootable on
vboxmanage storagectl ${vm_name} --name ${ctrlr_name2} --add "ide" --bootable on

vboxmanage storageattach ${vm_name} \
            --storagectl ${{ctrlr_name1}} \ 
            --port 00 \
            --device 00 \
            --type dvddrive \
            --medium "/Users/Min/Desktop/Joon/ACIT4640/CentOS-7-x86_64-Minimal-1810.iso"

vboxmanage storageattach ${vm_name} \
            --storagectl ${{ctrlr_name2}} \ 
            --port 01 \
            --device 01 \
            --type dvddrive \
            --medium "/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso"

vboxmanage storageattach ${vm_name} \
            --storagectl ${ctrlr_name1} \
            --port 01 \
            --device 01 \
            --type hdd \
            --medium "/Users/Min/VirtualBox VMs"/${vm_name}.vdi \
            --nonrotational on

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
