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
