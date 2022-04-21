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
git config --global user.name "your_name"
git config --global user.email your_email@example.com
```

## 创建安全密钥

* Linux密钥默认放在~/.ssh目录中
* Windows密钥默认放在%HOMEPATH%\.ssh
* 密钥文件：
  * 私钥: id_rsa
  * 公钥: id_rsa.pub
* 连接github、gitlab等，在用户设置中新建ssh并将公钥内容复制进去

```shell
# 生成过程中密码可以不输入
ssh-keygen -t rsa -C "your_email@example.com"
```

## 1.2. 设置line endings

参考网址：https://docs.github.com/cn/get-started/getting-started-with-git/configuring-git-to-handle-line-endings

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
#设置全局代理
git config --global http.proxy 'http://127.0.0.1:7890'
git config --global https.proxy 'http://127.0.0.1:7890'

#使用socks5代理的 例如ss，ssr 1080是windows下ss的默认代理端口,mac下不同，或者有自定义的，根据自己的改
git config --global http.proxy 'socks5://127.0.0.1:7890'
git config --global https.proxy 'socks5://127.0.0.1:7890'
 
#只对github.com使用代理，其他仓库不走代理
git config --global https.https://github.com.proxy 'http://127.0.0.1:7890'

#取消github代理
git config --global --unset https.https://github.com.proxy
 
#取消全局代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```
