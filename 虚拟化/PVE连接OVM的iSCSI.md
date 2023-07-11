# 在OVM创建iSCSI

## 安装tgt插件

在插件中搜索tgt

## 配置tgt

* 首先启用
* 添加Images，Path为镜像文件路径，Size为镜像文件尺寸
* 添加Targets，名称随便起，Backingstore是镜像文件路径，Initiator address填写允许访问iSCSI的主机IP地址

# 在pve连接iSCSI磁盘

## 连接iSCSI

```shell
# 发现iSCSI服务
iscsiadm -m discovery -t st -p 192.168.1.20:3260

# CHIP认证用户
iscsiadm -m node -T iqn名 --op update --name node.session.auth.username --value=用户名
# CHIP认证密码
iscsiadm -m node -T iqn名 --op update --name node.session.auth.password --value=密码

#连接
iscsiadm -m node -T iqn.2023-07.local.omv:iscsi1t -l

#设置开机启动
iscsiadm -m node -o update -n node.startup -v automatic
```

## 格式化并挂接分区

```shell
# 查看磁盘
fdisk -l

# 分区
fdisk /dev/sdd

# 挂接
mount /dev/sdd1 /mnt/iscsi
```

