# Linux下设置SoftEtherVPN客户端

## 下载客户端

去官网https://www.softether.org/下载Linux版本的客户端，例如：softether-vpnclient-v4.38-9760-rtm-2021.08.17-linux-x64-64bit.tar.gz

本文参考文章：https://www.cactusvpn.com/tutorials/how-to-set-up-softether-vpn-client-on-linux/

## 安装和设置

```shell
# 解压缩
tar xzvf softether-vpnclient-v4.38-9760-rtm-2021.08.17-linux-x64-64bit.tar.gz

# 进入解压目录
cd vpnclient

# 编译
./.install.sh

# 启动VPN Client
sudo ./vpnclient start

# 进入VPN Client配置
./vpncmd /CLIENT localhost

# 虚拟LAN卡，网卡名称可以随意起
NicCreate vpn_se

# 创建新的连接，创建过程中要填写服务器地址和端口、虚拟HUB名称、连接用户名、虚拟LAN卡名称
AccountCreate asfuyaovpn

# 设置连接密码，输入密码后指定standard或者radius时输入radius
AccountPassword asfuyaovpn

# 退出设置
exit
```

## 开始连接

```shell
# 创建startvpn.sh文件，输入下面内容，ip地址根据实际情况填写，最后一行是可选项，如系统设置值为1也可以设置路由（本人目前不会设置啊，只能硬来了）
./vpnclient start \
 && ./vpncmd /CLIENT localhost /cmd AccountConnect asfuyaovpn \
 && ip addr add 192.168.1.70/24 dev vpn_vpn_se \
 && echo 0 > /proc/sys/net/ipv4/ip_forward
 
# 连接
sudo sh startvpn.sh

```



