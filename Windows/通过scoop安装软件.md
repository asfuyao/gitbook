# Scoop也许是Windows平台最好的软件包管理器

## 安装设置

```powershell
# Optional: Needed to run a remote script the first time
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# 设置安装路径
$env:SCOOP='D:\scoop'
[environment]::setEnvironmentVariable('SCOOP',$env:SCOOP,'User')
```

## 国外镜像安装

```shell
# 安装
iwr -useb get.scoop.sh | iex

# 切换国内镜像
# 更换scoop的repo地址
scoop update
scoop config SCOOP_REPO 'https://gitee.com/glsnames/scoop-installer'
# 拉取新库地址
scoop update
```

## 国内镜像安装方法一

```shell
iwr -useb scoop.201704.xyz | iex
```



## 国内镜像安装方法二

```shell
iwr -useb https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1 | iex
scoop config SCOOP_REPO 'https://gitee.com/glsnames/scoop-installer'
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

# oh-my-posh，powershell最好去windows商店安装
scoop install oh-my-posh
# 安装后执行
New-Item -Path $PROFILE -Type File -Force
notepad $PROFILE
# 在文本文件中输入下面配置，保存退出后再次打开powershell生效
oh-my-posh init pwsh --config D:\scoop\apps\oh-my-posh\current\themes\stelbent-compact.minimal.omp.json | Invoke-Expression


# VC++运行时(需要管理员权限)
scoop install vcredist-aio
```

