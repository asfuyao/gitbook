---
layout:     post
title:      使用Choco快速配置开发环境
subtitle:   Choco
date:       2020-01-15
author:     Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:
    - Choco
    - Dev
    - Base
---

>Choco知识整理

<!-- TOC -->

- [介绍](#介绍)
- [官方网站](#官方网站)
- [安装方法](#安装方法)
- [简单使用](#简单使用)
- [批量安装](#批量安装)

<!-- /TOC -->

# 介绍
chocolatey是windows下的一个命令行的包管理工具，类似ubuntu的apt，或centos下的yum

# 官方网站

https://chocolatey.org

# 安装方法

需要在PowerShell的管理员权限下执行下面脚本：

```shell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

# 简单使用

安装好Choco后就可以用命令快速的安装需要的软件了

例如：
* choco install ChocolateyGUI
* choco install googlechrome
* choco install 7zip
* choco install vscode
* choco install visualstudio2017enterprise
* choco install sql-server-management-studio

# 批量安装
编辑以config结尾的文件，如：Package.config，输入以下内容：
```xml
<?xml version="1.0" encoding="utf-8"?>
    <packages>
      <package id="wechat" />
      <package id="7zip" />
      <package id="firefox"/>
      <package id="vscode" />
      <package id="visualstudio2017enterprise" />
      <package id="sql-server-management-studio" />
      <package id="sqltoolbelt" />
      <package id="tortoisesvn" />
      <package id="oracle-sql-developer" />
      <package id="office-tool" />      
    </packages>
```
然后使用命令`choco install Package.config`来批量安装所需的软件