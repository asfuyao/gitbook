# Scoop也许是Windows平台最好的软件包管理器

## 安装Scoop

```powershell
# Optional: Needed to run a remote script the first time
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# 设置安装路径
$env:SCOOP='D:\scoop'
[environment]::setEnvironmentVariable('SCOOP',$env:SCOOP,'User')

# 安装
iwr -useb get.scoop.sh | iex
```

## 下载加速和代理

```powershell
# 配置代理
scoop config proxy 127.0.0.1:7890
# 取消代理
scoop config rm proxy


# 安装下载加速
scoop install aria2
# scoop aria2设置
scoop config aria2-enabled false #关闭加速
scoop config aria2-warning-enabled false #关闭警告
scoop config aria2-options @('--check-certificate=false') #关闭证书检查
```

## 常用软件

```powershell
# 安装基础软件
scoop install 7zip git sudo

# 使用系统已经安装的7zip（可选）
scoop config '7ZIPEXTRACT_USE_EXTERNAL' $true

# vscode
scoop bucket add extras
scoop install vscode #安装后需要要导入注册表

# Cascadia-Code
scoop bucket add nerd-fonts
scoop install Cascadia-Code

# VC++运行时(需要管理员权限)
scoop install vcredist-aio
```

