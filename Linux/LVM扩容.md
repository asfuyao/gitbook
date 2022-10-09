# 分区扩容

编辑分区，假设要扩容的分区在sda3上

```shell
fdisk /dev/sda
```

删除sda3，然后再添加，注意起始扇区要一致，保存后执行下面命令

```shell
e2fsck -f /dev/sda3                #检查分区信息
resize2fs -p /dev/sda3             #调整分区大小
```

重启系统

# LVM扩容

```shell
lvresize -l +100%FREE ubuntu-vg/ubuntu-lv  #扩展逻辑卷
resize2fs -p /dev/ubuntu-vg/ubuntu-lv  #扩展文件系统
```

