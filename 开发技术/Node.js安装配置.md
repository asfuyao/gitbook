<!-- TOC -->

- [1. 安装Node.js版本管理NVM](#1-安装nodejs版本管理nvm)
- [2. 设置安装镜像](#2-设置安装镜像)
    - [2.1. 设置nvm node下载镜像](#21-设置nvm-node下载镜像)
    - [2.2. 设置nvm npm下载镜像](#22-设置nvm-npm下载镜像)
    - [2.3. 安装Node.js](#23-安装nodejs)
    - [2.4. 查看可用的版本列表](#24-查看可用的版本列表)
    - [2.5. 安装指定版本的Node.js](#25-安装指定版本的nodejs)
    - [2.6. 查看已安装的版本](#26-查看已安装的版本)
    - [2.7. 使用已安装的Node.js版本](#27-使用已安装的nodejs版本)
- [3. 设置js包管工具理镜像](#3-设置js包管工具理镜像)
    - [3.1. 设置npm镜像](#31-设置npm镜像)
    - [3.2. 设置yarn镜像](#32-设置yarn镜像)

<!-- /TOC -->

# 1. 安装Node.js版本管理NVM

* Windows版NVM官网：https://github.com/coreybutler/nvm-windows
* 下载nvm-setup.zip，解压缩后运行nvm-setup.exe进行安装（安装路径不能是中文、不能有空格）

# 2. 设置安装镜像

## 2.1. 设置nvm node下载镜像

```cmd
nvm node_mirror https://npm.taobao.org/mirrors/node/
```

## 2.2. 设置nvm npm下载镜像

```cmd
nvm npm_mirror https://npm.taobao.org/mirrors/npm/
```

## 2.3. 安装Node.js

## 2.4. 查看可用的版本列表

```cmd
nvm list available
```

查询结果：
|   CURRENT    |     LTS      |  OLD STABLE  | OLD UNSTABLE |
|--------------|--------------|--------------|--------------|
|    16.8.0    |   14.17.5    |   0.12.18    |   0.11.16    |
|    16.7.0    |   14.17.4    |   0.12.17    |   0.11.15    |
|    16.6.2    |   14.17.3    |   0.12.16    |   0.11.14    |
|    16.6.1    |   14.17.2    |   0.12.15    |   0.11.13    |
|    16.6.0    |   14.17.1    |   0.12.14    |   0.11.12    |
|    16.5.0    |   14.17.0    |   0.12.13    |   0.11.11    |
|    16.4.2    |   14.16.1    |   0.12.12    |   0.11.10    |
|    16.4.1    |   14.16.0    |   0.12.11    |    0.11.9    |
|    16.4.0    |   14.15.5    |   0.12.10    |    0.11.8    |
|    16.3.0    |   14.15.4    |    0.12.9    |    0.11.7    |
|    16.2.0    |   14.15.3    |    0.12.8    |    0.11.6    |
|    16.1.0    |   14.15.2    |    0.12.7    |    0.11.5    |
|    16.0.0    |   14.15.1    |    0.12.6    |    0.11.4    |
|   15.14.0    |   14.15.0    |    0.12.5    |    0.11.3    |
|   15.13.0    |   12.22.5    |    0.12.4    |    0.11.2    |
|   15.12.0    |   12.22.4    |    0.12.3    |    0.11.1    |
|   15.11.0    |   12.22.3    |    0.12.2    |    0.11.0    |
|   15.10.0    |   12.22.2    |    0.12.1    |    0.9.12    |
|    15.9.0    |   12.22.1    |    0.12.0    |    0.9.11    |
|    15.8.0    |   12.22.0    |   0.10.48    |    0.9.10    |

## 2.5. 安装指定版本的Node.js

```cmd
nvm install 14.17.5
```

## 2.6. 查看已安装的版本

查询结果前面有星号的为当前正在使用的版本

```cmd
nvm list
```

## 2.7. 使用已安装的Node.js版本

```cmd
nvm use 14.17.5
```

# 3. 设置js包管工具理镜像

## 3.1. 设置npm镜像

淘宝镜像
npm config set registry https://registry.npm.taobao.org/
官方镜像
npm config set registry https://registry.npmjs.org/

## 3.2. 设置yarn镜像

淘宝镜像
yarn config set registry https://registry.npm.taobao.org/
官方镜像
yarn config set registry https://registry.yarnpkg.com