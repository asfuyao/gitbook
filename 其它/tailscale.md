# 设置路由转发局域网

```shell
sudo tailscale up --advertise-routes 192.168.1.0/24 --accept-routes=false --accept-dns=false  --advertise-exit-node --reset
```