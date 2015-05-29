Options enabled:

 - VirtIO drivers:

    * CONFIG_VIRTIO=y
    * CONFIG_VIRTIO_PCI=y
    * CONFIG_VIRTIO_NET=m
    * CONFIG_VIRTIO_MMIO=m
    * CONFIG_VIRTIO_CONSOLE=m
    * CONFIG_VIRTIO_BLK=y
    * CONFIG_VIRTIO_BALLOON=m
	* CONFIG_SCSI_VIRTIO=m
	* CONFIG_HW_RANDOM_VIRTIO=m

 - live patching
 - full network options for router and load balancer

Build under Debian:

 # make-kpkg --append-to-version -4-kvm-amd64 --revision 4.0 --initrd --rootcmd fakeroot --config menuconfig -j 5 kernel_image modules_image
