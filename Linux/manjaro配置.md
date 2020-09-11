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

<!-- TOC -->

- [1. Manjaro安装后设置](#1-manjaro安装后设置)
    - [1.1. 查看系统信息](#11-查看系统信息)
    - [1.2. 换源](#12-换源)
    - [1.3. 安装字体](#13-安装字体)

<!-- /TOC -->

# 1. Manjaro安装后设置

## 1.1. 查看系统信息

```shell
inxi -Fx
```

## 1.2. 换源

* 使用以下命令，生成可用中国镜像站列表，刷新完列表之后会弹出来一个框让你选择软件源，这里的就都是国内源了，选择一个喜欢的就行（当然要选择两个以上也没问题。）

```shell
sudo pacman-mirrors -i -c China -m rank
```

* 添加Arch Linux 中文社区仓库

说明网址：`https://mirrors.tuna.tsinghua.edu.cn/help/archlinuxcn/`，
使用方法：在 /etc/pacman.conf 文件末尾添加以下两行：

```
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```

之后安装 archlinuxcn-keyring 包导入 GPG key。

* 升级系统

```shell
sudo pacman -Syyu
```

## 1.3. 安装字体

安装文泉驿字体

```shell
sudo pacman -Sy wqy-microhei wqy-bitmapfont wqy-microhei-lite wqy-zenhei
```

## 1.4 安装常用软件

```shell
sudo pacman -Sy remmina #远程桌面
```
