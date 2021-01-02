# 下载和安装

官方网站：https://www.openmediavault.org/，下载最新版复制到U盘

# 扩展包安装

官方网站：https://omv-extras.org/

```shell
wget -O - https://github.com/OpenMediaVault-Plugin-Developers/packages/raw/master/install | bash
```

# 更换国内源

如果遇到无法拉取 https 源的情况，请先使用 http 源并安装：

```shell
apt install apt-transport-https ca-certificates
```

替换源：/etc/apt/sources.list

```
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.bfsu.edu.cn/debian/ buster main contrib non-free
# deb-src https://mirrors.bfsu.edu.cn/debian/ buster main contrib non-free
deb https://mirrors.bfsu.edu.cn/debian/ buster-updates main contrib non-free
# deb-src https://mirrors.bfsu.edu.cn/debian/ buster-updates main contrib non-free
deb https://mirrors.bfsu.edu.cn/debian/ buster-backports main contrib non-free
# deb-src https://mirrors.bfsu.edu.cn/debian/ buster-backports main contrib non-free
deb https://mirrors.bfsu.edu.cn/debian-security buster/updates main contrib non-free
# deb-src https://mirrors.bfsu.edu.cn/debian-security buster/updates main contrib non-free
```

替换源：/etc/apt/sources.list.d/openmediavault.list

```
deb https://mirrors.bfsu.edu.cn/OpenMediaVault/public/ usul main
deb https://mirrors.bfsu.edu.cn/OpenMediaVault/public/ usul-proposed main
deb https://mirrors.bfsu.edu.cn/OpenMediaVault/public/ usul partner
```

替换了这个两个源以后其他的源可以先注释掉了