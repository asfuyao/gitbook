# NextCloud显示一直处于维护模式的处理办法

docker下的NextCloud在web页面升级时显示一直处于维护模式

## 先升级一下docker镜像

```shell
# 手工升级一次
docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower -cR \
    nextcloud nextcloud_mariadb

# 设置自动升级
docker run -d \
    --name watchtower \
    --restart unless-stopped \
    -e TZ=Asia/Shanghai \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower -c \
    --schedule "* * 12 * * *"
```

## 解除维护模式并手工升级

```shell
# 进入容器
docker exec -it nextcloud /bin/bash
# 执行命令解除维护模式
occ maintenance:mode --off
# 执行升级命令
occ upgrade
```
