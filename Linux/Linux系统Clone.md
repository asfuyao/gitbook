# GPT格式分区恢复Grub

从RescueCD引导系统，命令行执行：

```shell
mount /dev/sdb8 /mnt 
mount /dev/sdb6 /mnt/boot 
mount /dev/sdb2 /mnt/boot/efi
for i in /dev /dev/pts /proc /sys /run; do mount -B $i /mnt$i; done

sudo chroot /mnt

grub-install --target=x86_64-efi /dev/sdb

grub-install --recheck /dev/sdb
```



# 其他问题

* 启动出现错误提示：mdadm: no arrays found in config file or automatically，删除/etc/mdadm/mdadm.conf，执行`update-initramfs -u`