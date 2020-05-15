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

# 当上述步骤都做了还是提示Permission

denied，这时可以进入容器内部看看/home/git/.ssh/目录内的authorized_keys文件，看看这个文件里是否有你的pub key，如果没有就加一行，保存后重启容器

格式(每个pub key占一行)：

```shell
command="/app/gogs/gogs serv key-1 --config='/data/gogs/conf/app.ini'",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsclTsS3Pru9y3awEmo4nc9QKDi9wZVfAPlQO49V2XfDkMD++KK6EQajwbB+dCFpSBTgPBGCKSKVBZbmL3LCQsrqpR/gIWK3OTwQLKlkNpWHpzoJSsnflypwYn3IAqqVoN7em3P9AcxHmMzn4cJPjVLVJdTkoXPB7NEjzXeVVTGyyjd2pgo7mfkYF74n4re0g73II/IkHUibGmDXz6gjim9VNiRimJQ1L2Vdw7WMfxWVPv9FhxqC/KD9DYH/vGU18GWgWZT371OLi8SvoX2lAPbHfACrd5uHLFL3FzNv2/nnJy//SLTjAA7JMMhiDSQu84jkBpO7SgzjYfosLIQwhzuRlcDCb5yMGKAW112oAPV+rE9W0fMvCo3DLySEsEBCl9hPpaDBzHcH0kxDGH07HIsLhHIPfnFrTMf6TlHmkxBRvTtm6P7bISuhLR7INbU1KtF8ukWYlHL9NrP8pf8yrV0HmbOYD943gP4arDZBmSJA8a0rn/Ei6RzsDT2GNBsT0= asfuyao@qq.com
```

这个问题的产生原因不知道是什么情况，不理解为什么没有自动添加这个文件，有时候又好使可以自动添加