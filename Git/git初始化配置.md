<!-- TOC -->

- [1. 初始化设置](#1-初始化设置)
    - [1.1. 设置用户](#11-设置用户)
    - [1.2. 设置line endings](#12-设置line-endings)
    - [1.3. 解决中文乱码问题](#13-解决中文乱码问题)
    - [1.4. 配置默认编辑器](#14-配置默认编辑器)
    - [1.5. 通过代理联网](#15-通过代理联网)

<!-- /TOC -->

# 1. 初始化设置

## 1.1. 设置用户

```shell
git config --global user.name "asfuyao"
git config --global user.email asfuyao@qq.com
```
## 1.2. 设置line endings

```shell
# Windows
git config --global core.autocrlf true

# Linux & Mac
git config --global core.autocrlf input
```

## 1.3. 解决中文乱码问题

```shell
git config --global core.quotepath false
git config --global gui.encoding utf-8
git config --global i18n.commit.encoding utf-8
git config --global i18n.logoutputencoding utf-8
```

## 1.4. 配置默认编辑器

```shell
# Linux
git config --global core.editor vim
```

## 1.5. 通过代理联网

```shell
# 设置代理
git config --global http.proxy 'http://127.0.0.1:1081'
git config --global https.proxy 'http://127.0.0.1:1081'

# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```
