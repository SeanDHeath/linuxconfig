# Back up all VM XML files
VMs=$(sudo virsh list --all | awk '{print $2}' | sed '1d;2d;$d')
for vm in $VMs; do
	mkdir -p ~/vm/xml
	sudo virsh dumpxml $vm > ~/vm/xml/$vm.xml

tar --zstd -cf backup-$(date +%F) \
	~/.config/syncthing \
	~/.ssh \
	~/Camera \
	~/keepass \
	~/notes \
	~/sync \
	~/workspace \
	~/vm
