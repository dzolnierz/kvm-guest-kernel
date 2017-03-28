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

```
KERNEL_VERSION=4.9
PKG_BUILD=1
PKG_NAME=kvm
PKG_ARCH=amd64
PKG_REVISION=1.0

test -d build || { mkdir build ; cd $_ }
curl "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VERSION}.tar.xz"
tar -xJf "linux-${KERNEL_VERSION}.tar.xz" -C .
cd linux-${KERNEL_VERSION}
cp ../config-${KERNEL_VERSION} .
make olddefconfig
make-kpkg --append-to-version -$PKG_BUILD-$PKG_NAME-$PKG_ARCH --revision $PKG_REVISION \
	--initrd --rootcmd fakeroot --jobs $(nproc) kernel_image modules_image
```
