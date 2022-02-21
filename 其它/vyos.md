# VyOS

## 安装

```shell
# 启动后默认用户名和密码均为：vyos
# 安装命令
install image
```

## 系统设置

```shell
# 进入配置
configure

# 设置主机名
set system host-name vyos
# 设置时区
set system time-zone Asia/Shanghai
commit;save
```

## 配置局域网管理地址

```shell
configure
# 局域网卡
set interfaces ethernet eth0 address '192.168.91.1/24'
set interfaces ethernet eth0 duplex auto
set interfaces ethernet eth0 description 'LAN0'
# 启动ssh服务器
set service ssh port 222
commit;save

# 配置其他网卡
set interfaces ethernet eth1 duplex auto
set interfaces ethernet eth1 description 'LAN1'
set interfaces ethernet eth2 duplex auto
set interfaces ethernet eth2 description 'LAN2'
commit;save
```

## DHCP Client上网

```shell
set interfaces ethernet eth3 address dhcp
set interfaces ethernet eth3 description 'WAN0'
commit;save
#NAT 转发
set nat source rule 100 outbound-interface 'eth3'
set nat source rule 100 source address '192.168.91.0/24'
set nat source rule 100 translation address 'masquerade'
commit;save
```

## pppoe拨号上网

```shell
set interfaces ethernet eth3 description 'WAN'
set interfaces ethernet eth3 duplex 'auto'
set interfaces ethernet eth3 smp-affinity auto
set interfaces ethernet eth3 speed 'auto'
set interfaces pppoe pppoe0 source-interface 'eth3'
set interfaces pppoe pppoe0 default-route 'auto'
set interfaces pppoe pppoe0 mtu 1492
set interfaces pppoe pppoe0 authentication user 'as18593089'
set interfaces pppoe pppoe0 authentication password 'adsl12'
set interfaces pppoe pppoe0 connect-on-demand
set interfaces pppoe pppoe0 firewall in name NET-IN
set interfaces pppoe pppoe0 firewall local name NET-LOCAL
set interfaces pppoe pppoe0 firewall out name NET-OUT
commit;save
#NAT 转发
set nat source rule 100 outbound-interface 'pppoe0'
set nat source rule 100 source address '192.168.91.0/24'
set nat source rule 100 translation address 'masquerade'
commit;save
# TCP MSS
set policy route MSS description "TCP MSS clamping for PPPoE"
set policy route MSS rule 5 protocol tcp
set policy route MSS rule 5 tcp flags SYN
set policy route MSS rule 5 
set tcp-mss 1452
set interface ethernet eth3 pppoe 0 policy route MSS
set interface ethernet eth0 policy route MSS
set interface ethernet eth1 policy route MSS
set interface ethernet eth2 policy route MSS
commit;save
## pppoe连接，需退出配置配置模式
connect interface pppoe0
## pppoe断开
disconnect interface pppoe0
```

## DNS设置

```shell
set service dns forwarding cache-size '1500'
set service dns forwarding allow-from 192.168.91.0/24
set service dns forwarding listen-address 192.168.91.1
set service dns forwarding name-server '114.114.114.114'
set service dns forwarding name-server '223.6.6.6'
commit;save
```

## DHCP 服务端

```shell
set service dhcp-server shared-network-name LAN sub
net 192.168.91.0/24 default-router '192.168.91.1'
set service dhcp-server shared-network-name LAN subnet 192.168.91.0/24 dns-server '192.168.91.1'
set service dhcp-server shared-network-name LAN subnet 192.168.91.0/24 domain-name 'internal-network'
set service dhcp-server shared-network-name LAN subnet 192.168.91.0/24 lease '86400'
set service dhcp-server shared-network-name LAN subnet 192.168.91.0/24 range 0 start 192.168.91.150
set service dhcp-server shared-network-name LAN subnet 192.168.91.0/24 range 0 stop 192.168.91.199
commit;save
```

## 端口映射

```shell
set nat destination rule 1001 description 'KMS Server'
set nat destination rule 1001 destination port '1688'
set nat destination rule 1001 inbound-interface 'eth0'
set nat destination rule 1001 protocol 'tcp'
set nat destination rule 1001 source address 0.0.0.0/0
set nat destination rule 1001 translation address '192.168.91.2'
set nat destination rule 1001 translation port '1688'
commit;save
set nat destination rule 1002 description 'NextCloud'
set nat destination rule 1002 destination port '8088'
set nat destination rule 1002 inbound-interface 'eth0'
set nat destination rule 1002 protocol 'tcp'
set nat destination rule 1002 source address 0.0.0.0/0
set nat destination rule 1002 translation address '192.168.91.2'
set nat destination rule 1002 translation port '8088'
commit;save
set nat destination rule 1002 description 'gogs ssh'
set nat destination rule 1002 destination port '2222'
set nat destination rule 1002 inbound-interface 'eth0'
set nat destination rule 1002 protocol 'tcp'
set nat destination rule 1002 source address 0.0.0.0/0
set nat destination rule 1002 translation address '192.168.91.2'
set nat destination rule 1002 translation port '10022'
commit;save
set nat destination rule 1002 description 'gogs web'
set nat destination rule 1002 destination port '3000'
set nat destination rule 1002 inbound-interface 'eth0'
set nat destination rule 1002 protocol 'tcp'
set nat destination rule 1002 source address 0.0.0.0/0
set nat destination rule 1002 translation address '192.168.91.2'
set nat destination rule 1002 translation port '10080'
commit;save
set nat destination rule 1002 description 'OpenVPN Server'
set nat destination rule 1002 destination port '5717'
set nat destination rule 1002 inbound-interface 'eth0'
set nat destination rule 1002 protocol 'udp'
set nat destination rule 1002 source address 0.0.0.0/0
set nat destination rule 1002 translation address '192.168.91.2'
set nat destination rule 1002 translation port '1194'
commit;save
```

## 设置DDNS

```shell
# 公云PubYun
set service dns dynamic interface pppoe0 service custom-pubyun host-name asfuyao.f3322.org
set service dns dynamic interface pppoe0 service custom-pubyun login asfuyao
set service dns dynamic interface pppoe0 service custom-pubyun options ssl=no
set service dns dynamic interface pppoe0 service custom-pubyun password mypassword
set service dns dynamic interface pppoe0 service custom-pubyun protocol dyndns2
set service dns dynamic interface pppoe0 service custom-pubyun server www.pubyun.com
commit;save
```
