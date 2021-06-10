# 基本操作命令

Win+x 进入powershell(管理员)

```shell
# 获得系统安装的所有自带应用的名称和包全名
Get-AppxPackage | Select Name, PackageFullName
# 获取包信息
Get-AppxPackage -allusers [PackageName]

# 卸载当前用户指定的应用，需要包全名
Remove-AppxPackage [PackageFullName]

# 卸载当前用户指定的应用，可用通配符
Get-AppxPackage *[Name]* | Remove-AppxPackage

# 卸载所有用户指定的软件包
Get-AppxPackage -allusers *[Name]* | Remove-AppxPackage

```

# 卸载不需要的内置软件

```shell
# OneNote：
Get-AppxPackage *OneNote* | Remove-AppxPackage

# 3D：
Get-AppxPackage *3d* | Remove-AppxPackage

# Camera相机：
# Get-AppxPackage *camera* | Remove-AppxPackage

# 邮件和日历：
Get-AppxPackage *communi* | Remove-AppxPackage

# 新闻订阅：
Get-AppxPackage *bing* | Remove-AppxPackage

# Groove音乐、电影与电视：
Get-AppxPackage *zune* | Remove-AppxPackage

# 人脉：
Get-AppxPackage *people* | Remove-AppxPackage

# 手机伴侣（Phone Companion）：
Get-AppxPackage *phone* | Remove-AppxPackage

# 照片：
Get-AppxPackage *photo* | Remove-AppxPackage

# 纸牌游戏(还敢要钱的那货)：
Get-AppxPackage *solit* | Remove-AppxPackage

# 录音机：
# Get-AppxPackage *soundrec* | Remove-AppxPackage

# Xbox：
Get-AppxPackage *xbox* | Remove-AppxPackage

# office
Get-AppxPackage *office* | Remove-AppxPackage

# SkypeApp
Get-AppxPackage *SkypeApp* | Remove-AppxPackage

# map 地图
Get-AppxPackage *map* | Remove-AppxPackage

# Getstarted 技巧
Get-AppxPackage *getstarted* | Remove-AppxPackage

# GetHelp
# Get-AppxPackage *GetHelp* | Remove-AppxPackage

# FeedbackHub 反馈
Get-AppxPackage *FeedbackHub* | Remove-AppxPackage

# MixedReality混合实现门户
Get-AppxPackage *MixedReality* | Remove-AppxPackage
```
