# Manjaro Linux安装和配置

## 安装

* 语言选择：简体中文
* 时区选择：Asia/Shanghai（亚洲、上海）
* 磁盘分区格式：btrfs

## 设置软件源（GUI）

* 打开：软件包管理器 -> 首选项
* 进入：官方软件仓库，使用镜像 下拉框选择：China，然后刷新镜像列表

* 进入：AUR，启用AUR支持，选中 检查更新

## 设置软件源（CLI）

设置源

```shell
# 更新镜像排名，会出现窗口提供指定区域数据源供选择
sudo pacman-mirrors -i -c China -m rank
# 更新系统
sudo pacman -Syu
```

# 安装附加语言包

* 进入 设置，在系统类设置中点击Manjaro Settings Maager（Manjaro设置管理器）
* 打开 语言包，如 已安装的软件包 为可用状态就可以点击安装附加语言包

## 设置日期和时间

* 进入 设置，在系统类设置中点击Manjaro Settings Maager（Manjaro设置管理器）
* 打开 时间和日期，选中：自动设置时间和日期、本地区的硬件时钟
双系统设置时间`sudo timedatectl set-local-rtc 1`

## 安装必备的软件包

```shell

# 基本软件包
sudo pacman -S yay vim base-devel

# 字体，安装后将系统字体设置为 文泉驿微米黑 和 文泉驿等宽微米黑，打开gnome-tweaks将字体设置为文泉驿
yay -S wqy-bitmapfont wqy-microhei wqy-zenhei noto-fonts-cjk otf-cascadia-code-nerd

# fcitx5拼音输入法，需要注销重新进入后才能看到输入法图标
yay -S fcitx5 fcitx5-configtool fcitx5-chinese-addons fcitx5-gtk fcitx5-pinyin-zhwiki fcitx5-qt fcitx5-table-extra fcitx5-table-other manjaro-asian-input-support-fcitx5

# 新版本系统默认是zsh并且配置了powerlevel10k主题，修改主题配置
p10k configure

# v2ray
yay -S v2ray-desktop

# wps
yay -S wps-office-cn wps-office-mime-cn wps-office-fonts ttf-wps-fonts
yay -S wps-office wps-office-mime wps-office-mui-zh-cn wps-office-fonts ttf-wps-fonts

# docker
yay -S docker docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker <your-user>

# ZeroTier
yay -S zerotier-one
sudo systemctl enable zerotier-one.service
sudo systemctl start zerotier-one.service
sudo zerotier-cli join NetworkID

# 远程桌面
yay -S remmina remmina-plugin-rdesktop freerdp

# vmware需要安装内核header包，找到对应的内核包，例如内核版本为：6.1.12
yay -Ss headers |grep 6.1.12
yay -S linux61-headers

# chrome
yay -S google-chrome

# dotnet
yay -S dotnet-sdk dotnet-sdk-3.1

# visual code
yay -S visual-studio-code-bin

```

## 常用软件

* vim-clipboard 支持剪贴板的vim
* stacer 系统优化清理
* neofetch linux配置显示
* nodepadqq 文本编辑器
* zeal 电子文档
* tabby ssh客户端集成sftp
* electerm ssh客户端
* gnome-shell-extension-bing-wallpaper gnome的必应墙纸插件
* gnome-shell-extension-sound-output-device-chooser 快速切换声音输出源
* deadbeef 可以播放cue、ape格式的音乐播放器

## 常见问题

### 挂载磁盘需要权限

打开gnome-disks，选择要挂载的磁盘，编辑挂载选项，取消用户会话默认值选择，选择：系统启动时挂载、显示用户界面，其他默认即可

### 关机时间超长

编辑/etc/default/grub文件，再该文件下查找GRUB_CMDLINE_LINUX=”“一行，修改为：

```shell
#根据实际情况选择一种的引导方式
GRUB_CMDLINE_LINUX="reboot=efi"
#GRUB_CMDLINE_LINUX="reboot=bios"
#GRUB_CMDLINE_LINUX="reboot=acpi"
#GRUB_CMDLINE_LINUX="reboot=pci"
```

### 开机后黑屏

编辑/etc/default/grub文件
删除下面配置中的splash即可
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash apparmor=1 security=apparmor udev.log_priority=3"
