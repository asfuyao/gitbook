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
