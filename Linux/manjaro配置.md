---
layout:     post
title:      manjaro配置
subtitle:   Linux安装设置
date:       2019-07-03
author:     Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:
    - Linux
    - Manjaro
    - ArchLinux
---

>Linux 知识库

# Manjaro安装后设置

## 查看系统信息

```shell
inxi -Fx
```

## 换源

* 使用以下命令，生成可用中国镜像站列表，刷新完列表之后会弹出来一个框让你选择软件源，这里的就都是国内源了，选择一个喜欢的就行（当然要选择两个以上也没问题。）

```shell
sudo pacman-mirrors -i -c China -m rank
```

* 升级系统

```shell
sudo pacman -Syyu
```
