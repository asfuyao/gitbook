<!-- TOC -->

- [1. 下载Windows下的X Server](#1-下载windows下的x-server)
- [2. 运行Xming](#2-运行xming)
- [3. WSL安装xface4](#3-wsl安装xface4)
- [4. WLS配置](#4-wls配置)
    - [4.1. WSL 1](#41-wsl-1)
    - [4.2. WSL 2](#42-wsl-2)
- [5. 启动xface4](#5-启动xface4)

<!-- /TOC -->

# 1. 下载Windows下的X Server

下面两个X Server任选其一即可，配置方法类似

Xming下载地址：https://sourceforge.net/projects/xming/

VcXsrv下载地址：https://sourceforge.net/projects/vcxsrv/

首次运行许允许通过Windows防火墙

# 2. 运行并配置Xming

运行Xlaunch，进入配置向导，按下面步骤配置：

1. One window
2. Start no client
3. 如果是WLS2则需要选中No Access Control
4. 完成运行

# 3. WSL安装xface4

`sudo apt install xfce4`

# 4. WLS配置

## 4.1. WSL 1

修改.bashrc文件，添加下面内容：

```shell
export DISPLAY=0:0
```

## 4.2. WSL 2

查看主机地址：`cat /etc/reslov.conf`，里面的nameserver是WSL自动产生的即主机的地址，如果不想被自动更改需要在建立/etc/wsl.conf文件并填写下面内容：

```shell
[network]
generateResolvConf = false
```

修改.bashrc文件，添加下面内容：

```shell
export DISPLAY=主机IP地址:0
```

# 5. 启动xface4

配置好.bashrc后重新打开终端使配置生效，在终端中执行`startxfce4`