# 下载openwrt模板

网站：https://downloads.immortalwrt.org/
选择x86-64版本，rootfs.tar.gz
例如21.02.5版本的下载地址为：https://downloads.immortalwrt.org/releases/21.02.5/targets/x86/64/immortalwrt-21.02.5-x86-64-rootfs.tar.gz

# 上传模板

将下载的模板上传的pve的模板目录：/var/lib/vz/template/cache/

# 新建lxc虚拟机

进入pve控制台，执行下面命令：

```shell
pct create 100 /var/lib/vz/template/cache/immortalwrt-21.02.5-x86-64-rootfs.tar.gz --arch amd64 --hostname OpenWrt --rootfs disk1t:10 --memory 2048 --cores 2 --ostype unmanaged --unprivileged 1 --net0 name=eth0,bridge=vmbr0,gw=192.168.1.1,ip=192.168.1.100/24
```

请根据实际情况修改相应配置

# 修改IP地址

启动虚拟机后需要修改IP地址：

```shell
vi /etc/config/network

service network restart
```

# openwrt基本配置

进入openwrt：http://192.168.1.100

网络 -> 接口：添加网关、dns，关闭dhcp

# 安装openclash

下载地址：https://github.com/vernesong/OpenClash/releases

1. 进入openwrt控制台安装依赖：

```shell
#iptables
opkg update
opkg install coreutils-nohup bash iptables dnsmasq-full curl ca-certificates ipset ip-full iptables-mod-tproxy iptables-mod-extra libcap libcap-bin ruby ruby-yaml kmod-tun kmod-inet-diag unzip luci-compat luci luci-base
```

2. 进入openwrt管理web页面：

系统 -> 软件包，上传openclash软件包并安装

3. 服务 -> openclash -> Plugin Settings -> 版本更新

下载并手工上传缺失的插件到指定目录