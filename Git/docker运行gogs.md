---
layout: post
title:  docker运行gogs
subtitle:   Linux相关
date:   2020-05-11
author: Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:
- Linux
- Github
- Git
---

# 创建docker-compose.yml

```shell
version: "2"

services:

  gogs:
    image: docker.io/gogs/gogs:latest
    container_name: gogs
    ports:
      - "10022:22"
      - "10080:3000"
    volumes:
      - ./data:/data
    restart: always
```

# 运行容器

```shell
docker-compose up -d
```

# 配置gogs

- 进入http://IP:10080
- 域名：主机IP
- SSH端口号：映射后的端口号10022，同时选中使用内置SSH服务器
- HTTP端口号：默认的3000
- 应用URL：映射和的端口号，http://主机IP:10080

# SSH问题

客户端生成了key，也在服务端添加了key，但用SSH模式时还是提示Permission denied，这个问题的产生是改变了容器内.ssh目录和文件的权限导致的，解决方法是进入容器的命令行修改权限

```shell
docker exec -it gogs容器名 /bin/bash
```

进入容器后执行

```shell
chmod 0700 /home/git/.ssh
chmod 0600 /home/git/.ssh/*
```

