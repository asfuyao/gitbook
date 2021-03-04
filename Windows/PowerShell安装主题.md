## 准备工作

首先需要注意的是，`oh-my-posh` 主题使用了一些非 Powerline 字体不支持的字符，因此如果你使用默认的等宽字体（比如 `Consolas`），在显示过程中就会出现乱码、字符显示不全的现象。

Powerline 字体在 GitHub 开源，我们可以在这里： [powerline/fonts](https://github.com/powerline/fonts) 下载支持相关字符的字体。（如果你使用的是更纱黑体，那么就不必担心。）同时，请务必确认你所使用的终端支持你所想应用的自定义 Powerline 字体。

修改PowerShell配置文件，修改字体，添加下面内容：

```shell
Set-PoshPrompt -Theme slim
```



## 下载安装

我们通过在 PowerShell 中执行下面的命令安装配置 `oh-my-posh`。

### 安装 posh-git 和 oh-my-posh 这两个模块

```shell
Install-Module posh-git -Scope CurrentUser 
Install-Module oh-my-posh -Scope CurrentUser
```

如果是PS Core下，需要安装 `PSReadLine`

```
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
```

### 让 PowerShell 主题配置生效

#### 新增（或修改）你的 PowerShell 配置文件

```shell
# 如果之前没有配置文件，就新建一个 PowerShell 配置文件
if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }
用记事本打开配置文件
notepad $PROFILE
```

#### 在其中添加下面的内容

```shell
Import-Module posh-git 
Import-Module oh-my-posh 
Set-PoshPrompt -Theme slim
```