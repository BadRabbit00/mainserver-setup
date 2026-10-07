#!/bin/bash

D=/dev/nvme1n1
O=noatime,compress=zstd:1

mount -o $O,subvol=@home      ${D}p2 /mnt/home
mount -o $O,subvol=@snapshots ${D}p2 /mnt/.snapshots
mount -o $O,subvol=@log       ${D}p2 /mnt/var/log
mount -o $O,subvol=@pkg       ${D}p2 /mnt/var/cache/pacman/pkg
mount -o $O,subvol=@tmp       ${D}p2 /mnt/var/tmp
mount -o $O,subvol=@swap      ${D}p2 /mnt/swap
mount -o $O,subvol=@docker    ${D}p2 /mnt/var/lib/docker
mount -o $O,subvol=@libvirt   ${D}p2 /mnt/var/lib/libvirt/images
mount ${D}p1 /mnt/boot/efi

# права и отключение copy-on-write там, где оно мешает
chmod 1777 /mnt/var/tmp
chattr +C /mnt/var/lib/docker /mnt/var/lib/libvirt/images

# swap-файл (размер = объём твоей RAM, если нужна гибернация; иначе хватит 8g)
btrfs filesystem mkswapfile --size 16g --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile

