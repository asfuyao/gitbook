<!-- TOC -->

- [1. docker常用技巧](#1-docker常用技巧)
  - [1.1. 进入容器内部](#11-进入容器内部)
  - [1.2. 安装容器管理面板](#12-安装容器管理面板)
  - [1.3. 镜像加速](#13-镜像加速)
    - [1.3.1. 编辑daemon.json文件](#131-编辑daemonjson文件)
    - [1.3.2. 重启docker](#132-重启docker)

<!-- /TOC -->

# 1. docker常用技巧

## 1.1. 进入容器内部

```shell
docker exec -it 容器名 /bin/bash
```

## 1.2. 安装容器管理面板

```shell
docker run -d -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

## 1.3. 镜像加速

### 1.3.1. 编辑daemon.json文件

```json
{
    "iptables": false, //在linux下设置，可以使ufw防火墙规则设置生效，否则dockers会自己添加iptables规则，ufw无法阻止
    "registry-mirrors": [
        "https://registry.docker-cn.com",
        "http://docker.mirrors.ustc.edu.cn"
    ] //设置仓库镜像
}
```

### 1.3.2. 重启docker

```shell
# 守护进程重启
systemctl daemon-reload

# 重启docker服务
systemctl restart docker
service docker restart
```

## 1.4. 导出容器到镜像

### 1.4.1. 将容器打包成镜像

命令：docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
options选项：

* -a :提交的镜像作者；

* -c :使用Dockerfile指令来创建镜像；

* -m :提交时的说明文字；

* -p :在commit时，将容器暂停。

```shell
# 例如：打包openwrt
docker commit 26cd17e18f25 my_openwrt_buddha:V7.2022
```

  完成后，使用docker images可以看见该镜像

### 1.4.2. 打包镜像

命令：docker save [OPTIONS] IMAGE [IMAGE...]，这里的IMAGE是你刚打包的镜像，完成后会在当前目录生成一个tar文件。

```shell
# 例如：导出openwrt
docker save -o my_openwrt_buddha.tar my_openwrt_buddha:V7.2022
```

### 1.4.3. 新服务器载入镜像

命令：`docker load [OPTIONS]`
-option选项：–input,-i 指定导入的文件
–quiet,-q 精简输出信息

```shell
docker load --input my_jenkins.tar
```

完成后run容器即可

## 1.5. 查看docker资源占用情况

```shell
# 实时查看
docker stats

# 使用ctop
docker run --rm -ti \
  --name=ctop \
  --volume /var/run/docker.sock:/var/run/docker.sock:ro \
  quay.io/vektorlab/ctop:latest
```

