# 应用场景

* 有三台服务器，1号机、2号机、3号机，linux系统

* 其中2号机有双网卡，分别与1号机和3号机连接

* 在1号机上有db2数据库服务（端口50000），需要在3号机上进行访问

# 解决方案

假设三台服务器的IP地址分别为：

```shell
#1号机
192.168.1.51
#2号机
192.168.1.52
192.168.91.52
#3号机
192.168.91.53
```



在3号机上利用ssh连接2号机并创建本地创建socket5代理，监听本地端口8000，这个步骤需要2号机的root用户密码，如果要实现自动启动需要配置使用证书连接

```shell
ssh -N -f -D 8000 root@192.168.91.52
```

在3号机上创建防火墙规则将本地对端口50000的请求转发给socket5代理

```shell
iptables -t nat -N db2
iptables -t nat -A db2 -p tcp -j REDIRECT --to-ports 8000
iptables -t nat -A OUTPUT -d 192.168.1.51 -p tcp --dport 50000 -j db2
```

完成上述步骤后即可在3号机上直接访问192.168.1.51的50000端口

```shell
service iptables save
service iptables restart
```

