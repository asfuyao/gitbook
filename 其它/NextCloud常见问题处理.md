# NextCloud

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

## 手工升级

### 手动下载压缩包

复制升级包的下载链接，将压缩包手动下载到本机，然后上传到服务器的 `nextcloud/data/updater-xxxxxx/downloads` 文件夹下（xxxxxx 是一个随机字符串，请手动替换）

### 修改 .step 文件

在 `nextcloud/data/updater-xxxxxx/` 文件夹下有个 `.step` 文件，用于记录更新器执行到第几步了。不同的版本中「下载」所对应的步骤也不同，请根据你的版本进行更改。

```
{“state”:”start”,”step”:4}
```

我们需要更改为

```
{“state”:”stop”,”step”:5}
```

### 继续更新

此时再开始更新，就会自动跳过下载升级包的过程，然后按照正常更新步骤操作即可。我们可以选择命令行或者浏览器更新

**命令行更新（推荐）**

```
php nextcloud/updater/updater.phar
```

出现提示只需要回车即可
