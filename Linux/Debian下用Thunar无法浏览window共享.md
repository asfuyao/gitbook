# Thunar里输入smb://IP无法访问

thunar文件管理器不能浏览网络，但smb服务已经安装。打开thunar文件管理器，编辑——首选项——高级，提示问题出在缺少依赖项gvfs不可用。

```shell
sudo apt install gvfs gvfs-backends gvfs-fuse
```

如果不行需要卸载后重新安装

```shell
sudo apt remove gvfs
sudo apt autoremove
sudo apt install gvfs gvfs-backends gvfs-fuse
sudo apt remove thunar
sudo apt autoremove
sudo apt install thunar
```

最后，注销用户，重新登录。再次打开thunar文件管理器，左侧可看到浏览网络图标，点击后可以看到局域网共享设备。