# Scoop也许是Windows平台最好的软件包管理器

## 安装设置

```powershell
# Optional: Needed to run a remote script the first time
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# 设置安装路径
$env:SCOOP='D:\scoop'
[environment]::setEnvironmentVariable('SCOOP',$env:SCOOP,'User')

# 国内镜像安装
iwr -useb scoop.201704.xyz | iex

# 标准安装，适合有科学上网环境的
iwr -useb get.scoop.sh | iex
# 配置代理
scoop config proxy 127.0.0.1:7890
# 取消代理
scoop config rm proxy
```

## 添加bucket

```powershell
scoop bucket add extras
scoop bucket add nerd-fonts
```

## 安装常用软件

* 其他软件去scoop.sh搜索
* 安装软件后注意提示信息，有的软件需要导入注册表文件

```powershell
# 安装字体
scoop install Cascadia-Code Hack-NF Hack-NF-Mono

# 基础软件
scoop install 7zip git sudo

# 安装下载加速
scoop install aria2
# scoop aria2设置
scoop config aria2-enabled false #关闭加速
scoop config aria2-warning-enabled false #关闭警告
scoop config aria2-options @('--check-certificate=false') #关闭证书检查

# 先去最好去windows商店安装powershell
# 然后安装windows-terminal、oh-my-posh
scoop install windows-terminal
scoop install oh-my-posh
# 安装后执行
New-Item -Path $PROFILE -Type File -Force
notepad $PROFILE
# 在文本文件中输入下面配置，保存退出后再次打开powershell生效
oh-my-posh init pwsh --config D:\scoop\apps\oh-my-posh\current\themes\stelbent-compact.minimal.omp.json | Invoke-Expression
```

## 重装系统后还原

* 1. 修改环境变量, 在用户环境变量中，新建一个名为SCOOP的变量，值为当前scoop文件夹的地址D:\scoop，在环境变量path中新增一条%SCOOP%\shims

* 2. 允许脚本执行:

```powershell
set-executionpolicy remotesigned -s currentuser
```

* 3.powershell中运行：`scoop reset *`，即可恢复所有软件的图标和环境变量

* 4. 很多软件的配置文件在%USERPROFILE%中，如：.ssh、.config等需要在重装系统前北方出来，重装系统后复制回去即可

* 5. 有些软件需要导入注册表或执行初始化脚本，如：vscode要导入右键菜单注册表文件

## 一些软件

|        软件名        |                             说明                             |
| :------------------: | :----------------------------------------------------------: |
|       audacity       |    An easy-to-use, multi-track audio editor and recorder     |
|       calibre        |           Powerful and easy to use e-book manager            |
|       captura        |  Capture Screen, Audio, Cursor, Mouse Clicks and Keystrokes  |
|       deskreen       |  Turn any device into a secondary screen for your computer   |
|        ditto         |                An enhanced clipboard manager                 |
|         dia          |                       Drawing software                       |
|       fiddler        | The free web debugging proxy for any browser, system or platform |
|    gitextensions     | A graphical user interface for Git that allows you to control Git without using the commandline |
|      handbrake       | A tool for converting video from nearly any format to a selection of modern, widely supported codecs |
|       heidisql       | See and edit data and structures from computers running one of the database systems MariaDB, MySQL, Microsoft SQL or PostgreSQL |
|       jpegview       | Fast and highly configurable image viewer/editor with a minimal GUI |
|     musicplayer2     | Audio player which supports music collection playback, lyrics display, format conversion and many other functions |
|       coretemp       |  Monitor processor temperature and other vital information   |
|         gimp         |                GNU Image Manipulation Program                |
|    flow-launcher     | Quick file searcher and app launcher with community-made plugins |
|      fscapture       | A powerful, lightweight, yet full-featured screen capture tool and screen video recorder |
|       landrop        |             Drop any files to any devices on LAN             |
|      guiscrcpy       | A simple, pluggable, graphical user interface for the fastest Android screen mirroring software, scrcpy |
|        scrcpy        |           Display and control your Android device            |
|       obsidian       | Powerful knowledge base that works on top of a local folder of plain text Markdown files |
|        mqttx         |                   MQTT 5.0 Desktop Client                    |
| librehardwaremonitor | A fork of Open Hardware Monitor, a free software that can monitor the temperature sensors, fan speeds, voltages, load and clock speeds of your computer |
|     pgadmin4-np      |      PostgreSQL administration and development platform      |
|        tabby         |               A terminal for a more modern age               |
|      obs-studio      |         Video recording and live streaming software          |
|        sharex        |      Screen capture, file sharing and productivity tool      |
|        sigil         |                      EPUB ebook editor                       |
|    thorium-reader    | A cross platform desktop reading app, based on the Readium Desktop toolkit |
|       tightvnc       |        VNC-Compatible Remote Control / Remote Desktop        |
|      vncviewer       |                Control VNC enabled computers                 |
|       ultravnc       | UltraVNC Server and Viewer can display the screen of one computer (Server) on the screen of another (Viewer) |
|      wireshark       | A network protocol analyzer that lets you see what’s happening on your network at a microscopic level |
|        winscp        | Copy files between a local computer and remote servers using FTP, FTPS, SCP, SFTP, WebDAV or S3 file transfer protocols |
|        trippy        | Trippy combines the functionality of traceroute and ping and is designed to assist with the analysis of networking issues |
|        vysor         |                Mirror and Control your Phone                 |
|      peerblock       |  An IP filter for Windows 7/10, forked from PeerGuardian 2   |
|   timeseriesadmin    | Administration panel and querying interface for InfluxDB databases |
|    syncthingtray     |                Tray application for Syncthing                |
|      syncthing       |         Open Source Continuous File Synchronization          |
|       snipaste       | A snipping tool, which allows you to pin the screenshot back onto the screen |
|        rustup        |         Manage multiple rust installations with ease         |
|       rustdesk       |   An open-source remote desktop software, written in Rust    |
|        picgo         |                    Image uploader/manager                    |
|      qalculate       |                   Multi-purpose calculator                   |
|        msys2         |     A software distro and building platform for Windows      |
|        motrix        |               A full-featured download manager               |
| neatdownloadmanager  | A simple and lightweight GUI wrapped around a powerful and optimized Download-Engine |
|    listen1desktop    |               One for all free music in China                |
|        mp3tag        | Powerful and easy-to-use tool to edit metadata of audio files |
|        pandoc        |              Pandoc filter for cross-references              |
|        putty         | A free implementation of SSH and Telnet, along with an xterm terminal emulator |
|      honeyview       |                     A fast image viewer                      |
