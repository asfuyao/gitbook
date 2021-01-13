# WindowsTerminal优化设置

## 安装Powerline字体

可以从 [Cascadia Code GitHub](https://github.com/microsoft/cascadia-code/releases) 发布页安装这些字体，下载后安装这四个字体：CascadiaCode.ttf、CascadiaCodePL.ttf、CascadiaMono.ttf、CascadiaMonoPL.ttf

字体说明：

| 字体名称         | 包括连字 | 包括 Powerline 字形 |
| :--------------- | :------- | :------------------ |
| Cascadia Code    | 是       | 否                  |
| Cascadia Mono    | 否       | 否                  |
| Cascadia Code PL | 是       | 是                  |
| Cascadia Mono PL | 否       | 是                  |

## 安装Posh-Git和Oh-My-Posh

在PowerShell下安装Posh-Git 和 Oh-My-Posh（需要先安装Windows版Git）

```powershell
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
```

如果使用的是 PowerShell Core，需要安装PSReadline

```powershell
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck
```

## 自定义 PowerShell 提示符

查看PowerShell配置文件位置：`echo $PROFILE`，编辑配置文件（如果没有则新建一个），文件末尾添加下面内容

```powershell
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox
```

现在，每个新实例启动时都会导入 Posh-Git 和 Oh-My-Posh，然后从 Oh-My-Posh 设置 Paradox 主题。 Oh-My-Posh 附带了若干[内置主题](https://github.com/JanDeDobbeleer/oh-my-posh#themes)

## 在设置中将 Cascadia Code PL 设置为 fontFace

Windows Terminal配置文件 settings.json 文件现在应如下所示：

```json
{
    // Make changes here to the powershell.exe profile.
    "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
    "name": "Windows PowerShell",
    "commandline": "powershell.exe",
    "fontFace": "Cascadia Code PL",
    "hidden": false
},
{
    "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
    "hidden": false,
    "name": "PowerShell",
    "source": "Windows.Terminal.PowershellCore",
    "fontFace": "Cascadia Mono PL"
},
{
    "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
    "hidden": false,
    "name": "Ubuntu",
    "source": "Windows.Terminal.Wsl",
    "fontFace": "Cascadia Mono PL",
    //配置起始路径
    "startingDirectory": "//wsl$/Ubuntu/home/fuyao"
}
```

## 设置背景透明

在default中加入下面设置：

```json
"useAcrylic": true, //开启亚巧克力特效
"acrylicOpacity" : 0.8 //设置透明度，0为全透明
```
