---
layout:     post
title:      PVE安装后要做的
subtitle:   虚拟化
date:       2019-05-31
author:     Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:
    - Linux
    - PVE
    - Debian
---

>Linux 知识库

<!-- TOC -->

- [1. 修改root的bash设置](#1-修改root的bash设置)
- [2. 修改源设置，去掉企业订阅](#2-修改源设置去掉企业订阅)
- [3. 增加PVE源并更新](#3-增加pve源并更新)
- [4. 打开Pci passthrough](#4-打开pci-passthrough)
    - [1) 修改启动设置](#1-修改启动设置)
    - [2）增加模块](#2增加模块)
- [5. 移除登录时的未订阅弹窗提示](#5-移除登录时的未订阅弹窗提示)
- [6. 调整LVM分区（可选）](#6-调整lvm分区可选)
    - [可选操作1](#可选操作1)
    - [可选操作2](#可选操作2)
- [7. 在安装时选择控制磁盘空间大小](#7-在安装时选择控制磁盘空间大小)
- [8. 使用zfs文件系统](#8-使用zfs文件系统)

<!-- /TOC -->

# 1. 修改root的bash设置

去掉下面内容的注释

```shell
cd
vi .bashrc
```

```bash
# You may uncomment the following lines if you want `ls' to be colorized:
 export LS_OPTIONS='--color=auto'
 eval "`dircolors`"
 alias ls='ls $LS_OPTIONS'
 alias ll='ls $LS_OPTIONS -l'
 alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
 alias rm='rm -i'
 alias cp='cp -i'
 alias mv='mv -i'
```

# 2. 修改源设置，去掉企业订阅

注释掉下面配置文件的内容

```sh
vi /etc/apt/sources.list.d/pve-enterprise.list
```

# 3. 增加PVE源并更新
如有内核更新需重启

```sh
echo "deb http://download.proxmox.com/debian/pve stretch pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
wget http://download.proxmox.com/debian/proxmox-ve-release-5.x.gpg -O /etc/apt/trusted.gpg.d/proxmox-ve-release-5.x.gpg

apt update -y
apt dist-upgrade -y
```

# 4. 打开Pci passthrough

* [官方说明网址](https://pve.proxmox.com/wiki/Pci_passthrough)

* 前提是CPU支持，pve官网说只有部分i7和大部分志强E3、E5支持

## 1) 修改启动设置

编辑grub

`vi /etc/default/grub`

修改这行

`GRUB_CMDLINE_LINUX_DEFAULT="quiet"`

改为

`GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"`

更新引导记录

`update-grub`

## 2）增加模块

修改配置文件

`vi /etc/modules`

添加下面内容：

```
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

# 5. 移除登录时的未订阅弹窗提示

* 没有订阅企业版每次登录Web管理时都会出现一个“No Valid Subscription(无有效订阅)”的提示，需要修改一个文件就可以去掉这个提示
* 5.1版的文件为“/usr/share/pve-manager/js/pvemanagerlib.js”，5.3版的文件换成了“/usr/share/javascript/proxmox–widget–toolkit/proxmoxlib.js”
* 修改一下其中的认购状态检查的判断代码即可
* 找到`if (data.status !== ‘Active’) {`，将其修改为`if (false) {`
* 也可以在shell下通过一个命令来完成这个修改

5.1版

`/usr/share/pve-manager/js/pvemanagerlib.js`

```shell
sed -i_orig "s/data.status !== 'Active'/false/g" /usr/share/pve-manager/js/pvemanagerlib.js && systemctl restart pveproxy.service
```

5.3版

`/usr/share/javascript/proxmox–widget–toolkit/proxmoxlib.js`

```
sed -i_orig "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
```

# 6. 调整LVM分区（可选）

* PVE的LVM有两种，Thin和非Thin，LVM-Thin只能存放Disk image和Container，LVM能够存放更多类型的内容但缺点是：只能使用raw磁盘格式、不能创建快照、必须完整分配磁盘空间
* 安装系统时会自动创建LVM和LVM-Thin，其中LVM是root分区通常占用整个磁盘的10%左右，剩余部分除了分给swap分区（大小和内存相等）都给了LVM-Thin
* 可以通过LVM管理命令将LVM-Thin容量都分给LVM，或删除LVM-Thin重新创建新的LVM分区

## 可选操作1

将LVM-Thin分区删除，容量分给LVM

```shell
echo 删除LVM-Thin分区，该分区的默认路径是/dev/pve/data，可通过lvdisplay命令查看
lvremove /dev/pve/data

echo 查看卷组剩余空间
vgdisplay pve | grep Free

echo 扩展root卷，例如增加4096M
lvextend -L +4096M /dev/pve/root

echo 扩展文件系统
resize2fs -p /dev/pve/root
```

## 可选操作2

将LVM-Thin分区删除，创建新的LVM

* 格式化后返回web控制台，在Datacenter节点的Storage菜单中添加新的Directory，Directory填/mnt/data，ID随便填，保持后就可以在左侧树菜单中看到新加的存储
```shell
echo 删除LVM-Thin分区，该分区的默认路径是/dev/pve/data，可通过lvdisplay命令查看
lvremove /dev/pve/data

echo 查看卷组剩余空间
vgdisplay pve | grep Free

echo 在卷组pve中创建卷data
lvcreate -l 4096M -n data pve

echo 这时还可以继续创建LVM-Thin卷，使用命令转换：lvconvert --type thin-pool pve/data

echo 格式化data卷
mkfs.ext4 /dev/pve/data

echo 创建挂载目录，并挂载卷
mkdir /mnt/data
mount /dev/pve/data /mnt/data

echo 在/etc/fstab中增加自动挂载
echo /dev/pve/data /mnt/data ext4 defaults 0 0 >> /etc/fstab
```

# 7. 在安装时选择控制磁盘空间大小

* 安装时选择hdsize，指定pve的LVM卷的总体大小，保留未分配空间
* 未分配空间可以通过fdisk命令来创建新的分区或用LVM管理命令创建卷
* fdisk创建的新分区可以格式化为ext4、xfs、btrfs，并挂接到系统中，方法查考“可选操作2”中的格式化之后的步骤

# 8. 使用zfs文件系统

* fdisk创建的新分区也可以创建zfs系统，使用命令：`zpool create -f -o ashift=12 存储池名 /dev/sda4`
* 查看zfs存储池：`zpool list`
* 设置zfs压缩：`zfs set compression=on 存储池名`
* 创建完zfs pool后可在web控制台在Datacenter节点的Storage菜单中添加新的zfs存储，添加时ZFS pool选择刚才创建的，ID随便填，确认后会以对应的ID值在磁盘根目录创建目录，例如ID填写为zfsdisk
* zfs存储只能存放Disk image和Container，如果需要在zfs卷中放入iso等内容则可以创建zfs卷下的目录，例如如使用命令创建存放iso的目录：zfs create zfsdisk/iso，创建后在Datacenter节点的Storage菜单中添加新的Directory指向刚才创建的iso即可