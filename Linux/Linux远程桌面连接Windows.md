# Linux通过RDP协议连接Windows远程桌面

## 通过Remmina连接

Remmina是一款优秀的图形化远程管理工具，通过插件支持各种协议，其中包括Windows远程桌面的RDP协议，在首选项的RDP协议设置中可以控制远程桌面的缩放因子，例如希望连接后远程系统缩放为125%，可以设置桌面缩放因子为125、设备缩放因子为100

```shell
# 安装主程序和rdp插件
sudo apt install remmina remmina-plugin-rdp
```

## 通过xfreerdp连接

xfreerdp字符界面的RDP协议连接工具，功能完整性要超过Remmina+RDP插件，特别是支持多显示器，全屏退出时使用Ctrl+Alt+Enter

```shell
# 支持多显示器、映射远程音频（包括播放设备和录音设备）、支持剪贴板
xfreerdp /multimon /scale:100 /scale-desktop:125 /gfx-h264:AVC444 /smart-sizing /audio-mode:0 /sound:sys:pulse /microphone:sys:pulse /u:UserName /p:Password /v:RemoteIP +aero +window-drag +clipboard +fonts -wallpaper -window-drag
```

参数解析:

```shell
/multimon #启用多显示器
/scale:100 #设备缩放因子
/scale-desktop:125 #桌面缩放因子
/gfx-h264:AVC444 #英文解释：RDP8.1 graphics pipeline using H264 codec，不知道啥意思，经过各种测试加这个参数连接速度快、显示质量好
/smart-sizing #将远程桌面缩放到当前窗口大小，不会改变远程分辨率
/dynamic-resolution #动态修改远程桌面分辨率以适应窗口大小，不能和smart-sizing同时使用
/audio-mode:0 #音频模式，映射到本地
/sound:sys:pulse #音频播放映射到本地pulse设备
/microphone:sys:pulse #麦克风映射到本地pulse设备
+aero #使用桌面合成器
-window-drag #禁用用窗口拖拽，提高流畅度
-wallpaper #禁用桌面墙纸
+clipboard #使用剪贴板
+fonts #使用平滑自体
```
