---
layout:     post
title:      Windows下用Xming远程开启Linux图形界面程序
subtitle:   日常维护
date:       2019-06-17
author:     Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:
    - Linux
    - Windows
    - ssh
---

>Linux 知识库

# 前言

* putty可以执行字符界面的命令，但开启图形界面的命令, 如firefox。我们可以用Putty+Xming来远程运行Linux下的图像界面程序。

* 本教程操作系统为debian9

* MobaXterm默认开启X11 forwarding，可直接使用

# 1. 安装openssh-server和xbase-clients

```shell

sudo apt install openssh-server
sudo apt install xbase-clients

```

# 2. 下载Xming和Putty

http://sourceforge.net/projects/xming

https://www.putty.org/

# 3. 安装xming，一路默认

# 4. Putty开启X11 forwarding转发

# 5. Putty远程ssh连接可以开启图形化程序了