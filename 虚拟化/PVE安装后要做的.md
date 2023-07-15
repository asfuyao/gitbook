# pve安装设置(8.0适用)

## 修改root的bash设置

去掉~/.bashrc里下面内容的注释

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

## 修改源设置

* 注释掉/etc/apt/sources.list.d/pve-enterprise.list里面的内容
* 更换源为国内源(pve8)

```shell
cat > /etc/apt/sources.list <<EOF
deb https://mirrors.huaweicloud.com/debian/ bookworm main non-free contrib
# deb-src https://mirrors.huaweicloud.com/debian/ bookworm main non-free contrib
deb https://mirrors.huaweicloud.com/debian-security/ bookworm-security main
# deb-src https://mirrors.huaweicloud.com/debian-security/ bookworm-security main
deb https://mirrors.huaweicloud.com/debian/ bookworm-updates main non-free contrib
# deb-src https://mirrors.huaweicloud.com/debian/ bookworm-updates main non-free contrib
deb https://mirrors.huaweicloud.com/debian/ bookworm-backports main non-free contrib
# deb-src https://mirrors.huaweicloud.com/debian/ bookworm-backports main non-free contrib
EOF

# 下载秘钥
wget http://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
# 添加非订阅源
echo "deb http://mirrors.ustc.edu.cn/proxmox/debian/pve bookworm pve-no-subscription" >/etc/apt/sources.list.d/pve-no-subscription.list

# 更新系统
apt update -y && apt dist-upgrade -y
```

## 移除未使用的Linux内核

```shell
git clone https://github.com/jordanhillis/pvekclean.git
cd pvekclean
chmod +x pvekclean.sh
```

## 安装常用软件

```shell
apt install vim lrzsz unzip net-tools curl screen uuid-runtime git -y
```

## 安装并设置NTP服务

```shell
vim /etc/chrony/chrony.conf
# 新增下面的server

# Aliyun NTP
server ntp1.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp2.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp3.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp4.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp5.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp6.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp7.aliyun.com minpoll 4 maxpoll 10 iburst
```

## 打开Pci passthrough

* [官方说明网址](https://pve.proxmox.com/wiki/Pci_passthrough)

* 前提是CPU支持，pve官网说只有部分i7和大部分志强E3、E5支持

### 修改启动设置

编辑grub

 `vi /etc/default/grub`

修改这行

 `GRUB_CMDLINE_LINUX_DEFAULT="quiet"`

改为

 `GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"`

更新引导记录

 `update-grub`

### 增加模块

修改配置文件

 `vi /etc/modules`

添加下面内容：

```
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

## 移除登录时的未订阅弹窗提示

Proxmox VE 6.3 / 6.4 / 7.0 / 7.1 / 7.2 / 7.3 / 7.4 / 8.0 去掉未订阅的提示

```shell
sed -i_orig "s/data.status === 'Active'/true/g" /usr/share/pve-manager/js/pvemanagerlib.js
sed -i_orig "s/if (res === null || res === undefined || \!res || res/if(/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
sed -i_orig "s/.data.status.toLowerCase() !== 'active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
systemctl restart pveproxy
```

## 调整LVM分区（可选）

* PVE的LVM有两种，Thin和非Thin，LVM-Thin只能存放Disk image和Container，LVM能够存放更多类型的内容但缺点是：只能使用raw磁盘格式、不能创建快照、必须完整分配磁盘空间
* 安装系统时会自动创建LVM和LVM-Thin，其中LVM是root分区通常占用整个磁盘的10%左右，剩余部分除了分给swap分区（大小和内存相等）都给了LVM-Thin
* 可以通过LVM管理命令将LVM-Thin容量都分给LVM，或删除LVM-Thin重新创建新的LVM分区

### 可选操作1

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

### 可选操作2

将LVM-Thin分区删除，创建新的LVM

* 格式化后返回web控制台，在Datacenter节点的Storage菜单中添加新的Directory，Directory填/mnt/data，ID随便填，保持后就可以在左侧树菜单中看到新加的存储

```shell
echo 删除LVM-Thin分区，该分区的默认路径是/dev/pve/data，可通过lvdisplay命令查看
lvremove /dev/pve/data

echo 查看卷组剩余空间
vgdisplay pve | grep Free

echo 在卷组pve中创建卷data
lvcreate -l 4096M -n data pve
lvcreate -l 99%Free -n data pve

echo 转换data为thin-pool，PS如果卷组pve的剩余空间为0，将无法完成转换
lvconvert --type thin-pool pve/data

echo 也可以直接创建精简卷
lvcreate -l 100%Free --thin -n data pve

echo 格式化data卷
mkfs.ext4 /dev/pve/data

echo 创建挂载目录，并挂载卷，新版PVE不需要（/etc/pve/storage.cfg配置中有就可以了）
mkdir /mnt/data
mount /dev/pve/data /mnt/data
echo 在/etc/fstab中增加自动挂载
echo /dev/pve/data /mnt/data ext4 defaults 0 0 >> /etc/fstab
```

存储配置 (/etc/pve/storage.cfg)例子

```shell
lvmthin: local-lvm
         thinpool data
         vgname pve
         content rootdir,images
```

## 在安装时选择控制磁盘空间大小

* 安装时选择hdsize，指定pve的LVM卷的总体大小，保留未分配空间
* 未分配空间可以通过fdisk命令来创建新的分区或用LVM管理命令创建卷
* fdisk创建的新分区可以格式化为ext4、xfs、btrfs，并挂接到系统中，方法查考“可选操作2”中的格式化之后的步骤

## 使用zfs文件系统

* fdisk创建的新分区也可以创建zfs系统，使用命令：`zpool create -f -o ashift=12 存储池名 /dev/sda4`
* 查看zfs存储池：`zpool list`
* 设置zfs压缩：`zfs set compression=on 存储池名`
* 创建完zfs pool后可在web控制台在Datacenter节点的Storage菜单中添加新的zfs存储，添加时ZFS pool选择刚才创建的，ID随便填，确认后会以对应的ID值在磁盘根目录创建目录，例如ID填写为zfsdisk
* zfs存储只能存放Disk image和Container，如果需要在zfs卷中放入iso等内容则可以创建zfs卷下的目录，例如如使用命令创建存放iso的目录：zfs create zfsdisk/iso，创建后在Datacenter节点的Storage菜单中添加新的Directory指向刚才创建的iso即可
* 重装系统找回zfs磁盘，zpool import  查看，zpool import -f pool名  进行导入
zfs存储配置 (/etc/pve/storage.cfg)例子

```shell
zfspool: local-zfs
        pool rpool名称
        sparse
        content images,rootdir
```

* 修改名称，首先要屏蔽storage.cfg中的配置，先加上注释改好名后再去掉

```shell
zpool export rpool名称
zpool import rpool名称 新名称
```

* 导入zfs中已有文件到虚拟机

```shell
qm importdisk 101 vm-101-disk-0 local-zfs
qm rescan
```

## 使用技巧

### 导入img文件

```shell
qm importdisk 100 filename.img local-lvm
```

### VMware转换到PVE

* pve下创建虚拟机磁盘格式选qcow2
* 上传vmware的磁盘.vmdk文件
* 转换.vmdk到.qcow2，例：qemu-img convert -f vmdk old.vmdk -O qcow2 new.qcow2
* 移动转换好的磁盘替换现有磁盘，例：mv new.qcow2 /var/lib/vz/images/110/vm-110-disk-0.qcow2
