# pve 7.x 安装cockpit
## 添加源

```shell
echo deb http://mirrors.ustc.edu.cn/debian bullseye-backports main > /etc/apt/sources.list.d/backports.list

apt update
```

## 安装cockpit

```shell
apt install cockpit
```

## 安装插件

到下面地址下载deb包：

* cockpit-identities: https://github.com/45drives/cockpit-identities/releases
* cockpit-navigator: https://github.com/45Drives/cockpit-navigator/releases
* cockpit-file-sharing: https://github.com/45Drives/cockpit-file-sharing/releases

安装：

```shell
apt install ./cockpit-*.deb
```





