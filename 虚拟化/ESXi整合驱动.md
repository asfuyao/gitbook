<!-- TOC -->

- [1. 下载ESXi-Customizer-PS](#1-下载esxi-customizer-ps)
- [2. 安装VMware PowerCLI](#2-安装vmware-powercli)
- [3. 解除Windows禁止未经签名的PowerShell脚本运行](#3-解除windows禁止未经签名的powershell脚本运行)
- [4. 在线下载ESXi并整合驱动](#4-在线下载esxi并整合驱动)
- [5. 可用驱动列表](#5-可用驱动列表)
- [6. 离线整合驱动](#6-离线整合驱动)
- [使用ESXCLI将ESXi 6.5或6.7升级到ESXi 7.0](#使用esxcli将esxi-65或67升级到esxi-70)

<!-- /TOC -->

# 1. 下载ESXi-Customizer-PS

网址：https://www.v-front.de/p/esxi-customizer-ps.html

Github：https://github.com/VFrontDe/ESXi-Customizer-PS

# 2. 安装VMware PowerCLI

```powershell
#漫长的等待
Install-Module -Name VMware.PowerCLI
```

# 3. 解除Windows禁止未经签名的PowerShell脚本运行

```powershell
#管理员PowerShell下执行
#查看
Get-ExecutionPolicy -List
#解除限制
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
#还原默认设置
Set-ExecutionPolicy -ExecutionPolicy AllSigned
```

# 4. 在线下载ESXi并整合驱动

```powershell
.\ESXi-Customizer-PS.ps1 -v70 -vft -load net55-r8168
```

# 5. 可用驱动列表

https://vibsdepot.v-front.de/wiki/index.php/List_of_currently_available_ESXi_packages

# 6. 离线整合驱动

```powershell
#将下载的驱动方放入drv目录下
#生成iso文件
.\ESXi-Customizer-PS.ps1 -v70 -izip .\VMware-ESXi-7.0.1-16555998-depot.zip -pkgDir .\drv\
#生成部署包
.\ESXi-Customizer-PS.ps1 -v70 -izip .\VMware-ESXi-7.0.1-16555998-depot.zip -pkgDir .\drv\ -ozip
```

# 使用ESXCLI将ESXi 6.5或6.7升级到ESXi 7.0

```shell
#空运行升级以查看将要删除并安装哪些VIB
esxcli software sources profile list -d /vmfs/volumes/datastore1/ESXi-7.0.1-16555998-standard-customized.zip
#将主机置于维护模式
esxcli system maintenanceMode set --enable true
#运行升级，-p后面的名称在zip包里面查：zip包/metadata.zip/bulletins/ESXi-7.0.1-16555998-standard-customized.xml的文件名
esxcli software profile update -p ESXi-7.0.1-16555998-standard-customized -d /vmfs/volumes/datastore1/ESXi-7.0.1-16555998-standard-customized.zip
#重新启动主机
reboot

#如果遇到报Could not find a trusted signer错误，请添加--no-sig-check参数
esxcli software profile update -p ESXi-7.0.1-16555998-standard-customized -d /vmfs/volumes/datastore1/ESXi-7.0.1-16555998-standard-customized.zip --no-sig-check

#检查版本信息
esxcli system version get
```
