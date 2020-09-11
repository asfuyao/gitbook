<!-- TOC -->

- [1. 添加注册表项目](#1-添加注册表项目)
- [2. 替换FlashPlayer插件](#2-替换flashplayer插件)
    - [2.1. 查看FlashPlayer插件路径](#21-查看flashplayer插件路径)
    - [2.2. 安装防和谐版FlashPlayer](#22-安装防和谐版flashplayer)
    - [2.3. 替换chrome的FlashPlayer插件](#23-替换chrome的flashplayer插件)

<!-- /TOC -->

# 1. 添加注册表项目
此步骤为了打开Chrome对FlashPlayer的限制，新建注册表文件粘贴下面内容：

```reg
Windows Registry Editor Version 5.00  
 
[HKEY_CURRENT_USER\SOFTWARE\Policies\Chromium] 
"AllowOutdatedPlugins"=dword:00000001
"RunAllFlashInAllowMode"=dword:00000001
"DefaultPluginsSetting"=dword:00000001
"HardwareAccelerationModeEnabled"=dword:00000001
 
[HKEY_CURRENT_USER\SOFTWARE\Policies\Chromium\PluginsAllowedForUrls] 
"1"="https://vip.kingdee.com"
 
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome] 
"AllowOutdatedPlugins"=dword:00000001
"RunAllFlashInAllowMode"=dword:00000001
"DefaultPluginsSetting"=dword:00000001
"HardwareAccelerationModeEnabled"=dword:00000001
 
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\PluginsAllowedForUrls] 
"1"="https://vip.kingdee.com"
```

注：新版Chrome（85）已不支持带通配符的网址，如需加入多个网址支持只能一个一个的写如注册表

# 2. 替换FlashPlayer插件

## 2.1. 查看FlashPlayer插件路径

在chrome地址栏中输入：`chrome://version/`

## 2.2. 安装防和谐版FlashPlayer

下载地址：`https://masuit.com/1240?kw=flash`
chrome使用PP版：`Adobe_Flash_Player_PPAPI_v32.0.0.433.exe`

## 2.3. 替换chrome的FlashPlayer插件

复制C:\Windows\System32\Macromed\Flash\pepflashplayer.dll到chrome的FlashPlayer插件替换原有文件