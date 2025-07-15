# 安装手册

https://flathub.org/setup

# 常用命令

```shell
# 添加用户模式仓库
flatpak remote-add -u --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 已用户模式安装软件
flatpak install -u <remote> <package_name>

# 搜索 Flatpak 软件包
flatpak search <keyword>
# 从指定仓库安装 Flatpak 软件包。
flatpak install <remote> <package_name>
# 更新 Flatpak 软件包。
flatpak update <package_name>
# 卸载 Flatpak 软件包。
flatpak uninstall <package_name>
# 卸载未使用的包
flatpak uninstall --unused
# 查看已安装软件
flatpak list
# 看某个应用的安装路径
flatpak info --show-location <package_name>
# 看运行时映射
flatpak info --show-runtime <package_name>
# 运行应用程序
flatpak run <package_name>
# 导出应用程序，后缀名：.flatpak
flatpak export <package_name>
# 导入应用程序
flatpak install <filename>
```

# 常用软件

```shell
flatpak install flathub com.github.tchx84.Flatseal # Flatpak应用权限管理软件
flatpak install flathub io.github.vikdevelop.SaveDesktop # 桌面备份
flatpak install flathub com.google.Chrome
flatpak install flathub com.apifox.Apifox
```

