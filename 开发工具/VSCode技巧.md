---
layout:     post
title:      VSCode技巧
subtitle:   VSCode
date:       2020-01-15
author:     Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:
    - VSCode
    - Dev
    - Base
---

>VSCode知识整理

<!-- TOC -->

- [1. 设置](#1-%e8%ae%be%e7%bd%ae)
  - [1.1. 绿化](#11-%e7%bb%bf%e5%8c%96)
- [2. 插件](#2-%e6%8f%92%e4%bb%b6)
  - [2.1. Markdown TOC](#21-markdown-toc)

<!-- /TOC -->

# 1. 设置

## 1.1. 绿化
从官网下载vscode的zip版本，解压缩后就可以直接运行，但用户数据和插件会放到C盘的用户目录下，如果需要指定当前目录为工作目录需要进行如下操作：

* 创建目录：data
* 在data目录下创建两个目录：extensions 和 user-data

# 2. 插件

## 2.1. Markdown TOC

如果是Windows平台下，TOC标签格式异常出现如auto的文字，需要进行如下设置：
* 点击VSCode左下角的Manage按钮，进入Settings
* 输入Eol查找设置项
* 修改The default end of line character的设置值为：\n（默认为auto）

问题产生原因：
不同平台对换行符的制定不同，在自动转换保存时有所不同

系统|换行符
:-:|:-:
windows | \n\r
unix | \n
mac | \r