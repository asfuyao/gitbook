# 安装Command_Line_Tools_for_Xcode

下载网址：https://developer.apple.com/download/more/

# 安装brew

brew在国内安装非常慢甚至无法安装，需要开启代理

```shell
# 设置代理别名
proxyoff='unset all_proxy'
proxyon='export all_proxy=socks5://127.0.0.1:1080'
```

到brew官网找安装命令https://brew.sh/

# 常用软件

软件安装方式：brew install --cask 软件包名称

常用的软件包有：
google-chrome firefox nextcloud visual-studio-code kaka maczip iterm2 cheatsheet rectangle mounty eudic openvpn-connect tencent-meeting baidunetdisk gimp typora neteasemusic

# app store安装的软件

钉钉 QQ 微信 福昕阅读器

# 制作安装U盘

```shell
# 初始化U盘，清空分区和数据
sudo diskutil eraseDisk ExFAT 磁盘卷标 MBR disk6

# 制作Big Sur安装U盘
sudo /Applications/Install\ macOS\ Big\ Sur.app/Contents/Resources/createinstallmedia --volume /Volumes/磁盘卷标

```
