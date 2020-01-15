---
layout:     post
title:      快速部署trojan
subtitle:   翻墙
date:       2019-12-11
author:     Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:
    - linux
    - Trojan
    - CentOS
---

>快速部署trojan翻墙服务

<!-- TOC -->

- [系统要求](#系统要求)
- [CentOS7安装并开启bbr](#centos7安装并开启bbr)
    - [一键安装脚本](#一键安装脚本)
    - [安装bbr](#安装bbr)
    - [验证是否开启bbr](#验证是否开启bbr)
    - [安装trojan](#安装trojan)
        - [脚本功能](#脚本功能)

<!-- /TOC -->

# 系统要求

* 系统>=centos7，用centos8最好，内核可直接开启bbr不需升级。

# CentOS7安装并开启bbr

* 内容来源：https://teddysun.com/489.html

## 一键安装脚本

## 安装bbr
安装完成后，脚本会提示需要重启 VPS，输入 y 并回车后重启。

```shell
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
```

## 验证是否开启bbr

```shell
uname -r
```
* 查看内核版本，显示为最新版就表示 OK 了

```
sysctl net.ipv4.tcp_available_congestion_control
```
* 返回值一般为：`net.ipv4.tcp_available_congestion_control = bbr cubic reno`
* 或者为：`net.ipv4.tcp_available_congestion_control = reno cubic bbr`
```
sysctl net.ipv4.tcp_congestion_control
```
* 返回值一般为：`net.ipv4.tcp_congestion_control = bbr`
```
sysctl net.core.default_qdisc
```
* 返回值一般为：`net.core.default_qdisc = fq`
```
lsmod | grep bbr
```
* 返回值有`tcp_bbr`模块即说明 bbr 已启动。注意：并不是所有的 VPS 都会有此返回值，若没有也属正常。

## 安装trojan

* 内容来源：https://github.com/AaG7xNnrgbzeyqc5woPS/trojan-one-key-script-install/blob/master/onekeyscript_trojan

### 脚本功能
* 1、域名解析到VPS并生效。
* 2、脚本自动续签https证书
* 3、自动配置伪装网站，位于/usr/share/nginx/html/目录下，可自行替换其中内容

```
curl -O https://raw.githubusercontent.com/atrandys/trojan/master/trojan_centos7.sh && chmod +x trojan_centos7.sh && ./trojan_centos7.sh
```