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

# 安装下载加速
scoop install aria2
```

## 常用软件

```powershell
# vscode
scoop bucket add extras
scoop install vscode

# Cascadia-Code
scoop bucket add nerd-fonts
scoop install Cascadia-Code
```

