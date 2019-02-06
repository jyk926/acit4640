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

declare vm_folder="testVM"
declare size_in_mb="3600"
declare ctrlr_1="ctrl1"
declare ctrlr_2="ctrl2"
declare group_name=""
declare memory_mb="1280"
declare iso_file_path="/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso"

vboxmanage list natnetworks

vboxmanage natnetwork remove --netname ${network_name}

vboxmanage createvm --name ${vm_name} --register

vboxmanage createhd --filename "/"/${vm_name}.vdi \
                    --size ${size_in_mb} -variant Standard

vboxmanage storagectl ${vm_name} --name $ctrlr_1 --add "ide" --bootable on
vboxmanage storagectl ${vm_name} --name $ctrlr_2 --add "sata" --bootable on

vboxmanage storageattach ${vm_name} \
            --storagectl ${ctrlr_1} \ 
            --port 00 \
            --device 00 \
            --type dvddrive \
            --medium "/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso"
vboxmanage storageattach ${vm_name} \
            --storagectl ${ctrlr_2} \ 
            --port 01 \
            --device 01 \
            --type dvddrive \
            --medium "/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso"


vboxmanage storageattach ${vm_name} \
            --storagectl $ctrlr_1 \
            --port 01 \
            --device 01 \
            --type hdd \
            --medium "/Users/Min/VirtualBox VMs/test"/${vm_name}.vdi \
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
