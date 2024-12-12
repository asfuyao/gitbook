# Debian系统清理无用的软件包和残留文件

```shell
sudo apt update
sudo apt autoremove

#清理残留的配置文件：有时，卸载软件包后会保留一些残留的配置文件
sudo dpkg --purge $(dpkg -l | grep '^rc' | awk '{print $2}')

#清理已下载的软件包文件
sudo apt clean

#清理过期的软件包缓存
sudo apt autoclean
```