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

brew常用命令：

```shell
# 更新 Homebrew 仓库
brew update

# 安装
brew install 软件包名  #安装软件
brew install --cask 软件包名 #安装软件（二进制包）

# 查看哪些安装包需要更新
brew outdated

# 更新
brew upgrade             # 更新所有的包
brew upgrade 软件包名     # 更新指定的包

# 清理旧版本
brew cleanup             # 清理所有包的旧版本
brew cleanup 软件包名     # 清理指定包的旧版本
brew cleanup -n          # 查看可清理的旧版本包，不执行实际操作

# 锁定不想更新的包
brew pin 软件包名      # 锁定某个包
brew unpin 软件包名    # 取消锁定

# 查看安装包的相关信息
brew info 软件包名     # 显示某个包的信息
brew info             # 显示安装了包数量，文件数量，和总占用空间
brew deps --installed --tree # 查看已安装的包的依赖，树形显示

# 其他
# 列出已安装包
brew list
# 删除
brew rm 软件包名                # 删除某个包
brew uninstall --force 软件包名 # 删除所有版本

```

# 常用软件

软件安装方式：brew install --cask 软件包名称

常用的软件包有：

* google-chrome
* firefox
* nextcloud
* visual-studio-code
* kaka 解压缩工具
* maczip 解压缩工具
* iterm2
* cheatsheet 长按command快捷键提示
* rectangle 屏幕分割
* mounty ntfs磁盘挂接读写模式
* eudic 欧路词典
* openvpn-connect
* tencent-meeting 腾讯会议
* baidunetdisk
* gimp
* iina 视频播放器
* typora
* neteasemusic

其他：

* yacreader 看漫画
* zy-player 网络视频资源播放
* lx-music 落雪音乐，网络音乐聚合
* dia 流程图制作

# app store安装的软件

钉钉 QQ 微信 福昕阅读器

# 制作安装U盘

```shell
# 初始化U盘，清空分区和数据
sudo diskutil eraseDisk ExFAT 磁盘卷标 MBR disk6

# 制作Big Sur安装U盘
sudo /Applications/Install\ macOS\ Big\ Sur.app/Contents/Resources/createinstallmedia --volume /Volumes/磁盘卷标

```
