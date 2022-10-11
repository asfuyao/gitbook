# 常用操作

Linux命令搜索引擎：https://wangchujiang.com/linux-command/

## 文件系统

```shell
# 查看文件系统
df -T
lsblk -f

# 列出块设备信息，可查看磁盘空间占用
lsblk
```

## 系统版本

```shell
# 查看内核版本
uname -a

# 显示发行版本信息
lsb_release -a
cat /etc/os-release
```

## 网络信息

```shell
# 查看本机IP
hostname -I

# 查看网卡信息
ip a
ifconfig

# 查看端口占用
lsof -i
netstat -tunlp
# -t (tcp) 仅显示tcp相关选项
# -u (udp)仅显示udp相关选项
# -n 拒绝显示别名，能显示数字的全部转化为数字
# -l 仅列出在Listen(监听)的服务状态
# -p 显示建立相关链接的程序名

```

