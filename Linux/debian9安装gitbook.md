---
layout:     post
title:      debian9安装gitbook
subtitle:   日常维护
date:       2019-06-16
author:     Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:
    - Linux
    - debian
    - gitbook
---

>Linux 知识库

# 首先更新包并安装curl

```shell

apt update
apt upgrade
apt install curl

```

# 下载添加nodejs10源的脚本并运行

```shell

cd ~
curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
bash nodesource_setup.sh

```

# 安装nodejs10并查看版本号

```shell

apt install nodejs
nodejs -v
npm -v

```

# 安装编译工具包以支持一些npm包

```shell

apt install build-essential

```

# 安装GitBook并验证安装版本

```shell

npm install gitbook-cli -g
gitbook -V

```


# 初始化，GitBook可以设置一个样板书：

```shell

cd directory
gitbook init

```

# 构建

```shell

gitbook build

```

* 构建后会在项目的目录下生成一个 _book 目录，里面的内容为静态站点的资源文件
