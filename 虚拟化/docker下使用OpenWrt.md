# 新建macvlan网络

说明：

* vmbr0是pve的桥接网卡
* 网络范围：192.168.1.144/29，表示：ip地址范围是：192.168.1.145 ~ 192.168.1.150，掩码是：255.255.255.248
* 子网和网关都用宿主机的

```shell
sudo docker network create -d macvlan -o parent=vmbr0 eNet \
--subnet=192.168.1.0/24 \
--ip-range=192.168.1.144/29 \
--gateway=192.168.1.1
```

# 创建OpenWrt旁路由容器

```
sudo docker run -d --restart always --name OpenWrt --privileged --network eNet --ip=192.168.1.145 esirpg/buddha /sbin/init
```

# 修改容器IP地址
```shell
#进入容器
sudo docker exec -it OpenWrt ash

#修改IP地址
vi /etc/config/network

# 重启network进程
/etc/init.d/network restart
```