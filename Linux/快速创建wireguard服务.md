# 通过docker快速创建wirguard服务器

## 官方网站

https://github.com/wg-easy/wg-easy

## 运行命令

```shell
docker run -d \
  --name=wg-easy \
  -e PORT=51820 \
  -e LANG=en \
  -e WG_HOST=asfuyao.top \
  -e WG_DEVICE=vmbr0 \
  -e WG_PORT=8999 \
  -e PASSWORD=password \
  -e WG_DEFAULT_DNS= \
  -e WG_ALLOWED_IPS=192.168.1.0/24 \
  -e WG_PERSISTENT_KEEPALIVE=25 \
  -v /mnt/pve/usbdisk1t/docker/wg-easy:/etc/wireguard \
  -p 8999:51820/udp \
  -p 51821:51821/tcp \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  --restart unless-stopped \
  ghcr.io/wg-easy/wg-easy
```

可选参数说明：

|         参数名          |             说明             |
| :---------------------: | :--------------------------: |
|          PORT           |        web管理端端口         |
|         WG_PORT         | 生成客户端配置文件中的wg端口 |
|          LANG           |             语言             |
|         WG_HOST         |       外网访问域名或IP       |
|        WG_DEVICE        |         绑定网卡设备         |
|        PASSWORD         |      web管理端登录密码       |
|     WG_DEFAULT_DNS      |     dns为空表示不需要dns     |
|     WG_ALLOWED_IPS      |        允许访问的网段        |
| WG_PERSISTENT_KEEPALIVE |       保持连接心跳秒数       |

