# Manjaro Linux安装和配置

## 安装

* 语言选择：简体中文
* 时区选择：Asia/Shanghai（亚洲、上海）
* 磁盘分区格式：btrfs

## 设置软件源（GUI）

* 打开：软件包管理器 -> 首选项
* 进入：官方软件仓库，使用镜像 下拉框选择：Russia，然后刷新镜像列表（注：China的几个源都是试过了，都缺少文件，也不知道咋搞的，所以选择了相对比较快的Russia源）

* 进入：AUR，启用AUR支持，选中 检查更新

## 设置软件源（CLI）

设置源

```shell
# 更新镜像排名，会出现窗口提供指定区域数据源供选择
sudo pacman-mirrors -i -c China -m rank
# 更新数据源
sudo pacman -Syy
```

安装和设置AUR助手yay

```shell
sudo pacman -S yay
# 使用清华的AUR镜像
yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save
# 修改的配置文件位于 ~/.config/yay/config.json ，还可通过以下命令查看修改过的配置：
yay -P -g
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
# 基本软件bao
sudo pacman -S base-devel

# 字体，安装后将系统字体设置为 文泉驿微米黑 和 文泉驿等宽微米黑，打开gnome-tweaks将字体设置为文泉驿
sudo pacman -S wqy-microhei

# xfce4下fcitx5拼音输入法，需要注销重新进入后才能看到右下角的输入法图标
sudo pacman -S fcitx5 fcitx5-chinese-addons fcitx5-configtool fcitx5-gtk fcitx5-material-color fcitx5-qt
# 创建fcitx5环境变量
cat <<EOF > ~/.pam_environment
GTK_IM_MODULE DEFAULT=fcitx
QT_IM_MODULE  DEFAULT=fcitx
XMODIFIERS    DEFAULT=\@im=fcitx
SDL_IM_MODULE DEFAULT=fcitx
EOF
# 创建配置文件目录
mkdir ~/.config/fcitx5
# 创建配置文件
cat <<EOF > ~/.config/fcitx5/profile
[Groups/0]
# Group Name
Name=Default
# Layout
Default Layout=us
# Default Input Method
DefaultIM=rime

[Groups/0/Items/0]
# Name
Name=keyboard-us
# Layout
Layout=

[Groups/0/Items/1]
# Name
Name=rime
# Layout
Layout=

[GroupOrder]
0=Default
EOF

# 注销或重启启用fcitx5
# 修改拼音配置文件，或点击任务栏图标：配置->附加组件->拼音，点击设置图标
vim ~/.config/fcitx5/conf/pinyin.conf

# gnome下拼音，经测试会有选中剪切的问题
# sudo pacman -S ibus-pinyin

# 常用软件
sudo pacman -S vim git base-devel
# windows文件共享
sudo pacman -S smbclient
# v2ray
yay -S v2ray-desktop
# clash
yay -S clashy-bin
# wps
yay -S wps-office-cn wps-office-mui-zh-cn wps-office-fonts wps-office-mime-cn ttf-wps-fonts
# markdown编辑器typora
yay -S typora
# docker
sudo pacman -S docker docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker <your-user>
# ZeroTier
sudo pacman -S zerotier-one
sudo systemctl enable zerotier-one.service
sudo systemctl start zerotier-one.service
sudo zerotier-cli join NetworkID
# remmina
sudo pacman -S remmina freerdp
# vmware
sudo pacman -S linux510-headers

# chrome
yay -S google-chrome

# dotnet 5
yay -S dotnet-sdk-bin

# visual code
yay -S visual-studio-code-bin

# rider
yay -S rider

```

# 常用软件

* htop 基于终端的彩色进程查看
* tilix 一款终端软
* xfce4-terminal
* stacer 系统优化清理
* thunar xfce4的文件管理器
* neofetch linux配置显示
* nodepadqq 文本编辑器

# 常见问题

## 关机时间超长

编辑/etc/default/grub文件，再该文件下查找GRUB_CMDLINE_LINUX=”“一行，修改为：

```shell
#根据实际情况选择一种的引导方式
GRUB_CMDLINE_LINUX="reboot=efi"
#GRUB_CMDLINE_LINUX="reboot=bios"
#GRUB_CMDLINE_LINUX="reboot=acpi"
#GRUB_CMDLINE_LINUX="reboot=pci"
```

## 开机后黑屏

编辑/etc/default/grub文件
删除下面配置中的splash即可
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash apparmor=1 security=apparmor udev.log_priority=3"