---
layout:     post
title:      LSi 9211-8i 刷IT模式
subtitle:   硬件
date:       2019-06-17
author:     Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:
    - Hardware
    - ROM
    - Firmware
---

>硬件相关

# 下载固件和BIOS

[固件下载地址](https://docs.broadcom.com/docs/9211_8i_Package_P20_IR_IT_FW_BIOS_for_MSDOS_Windows.zip)

[Installer P20 for UEFI](https://docs.broadcom.com/docs/Installer_P20_for_UEFI.zip)

# Windows下刷ROM方式

## 1) 准备文件

* 在下载来的压缩包里找到这些文件，并将它们都放到同一个英文目录下

```cmd

Firmware\HBA_9211_8i_IT\2118it.bin
sasbios_rel\mptsas2.rom
sas2flash_win_x64_rel\sas2flash.exe

```

## 2）执行命令备份序列号

```cmd

sas2flash -list

```

* 执行后输出内容：

```cmd

LSI Corporation SAS2 Flash Utility
Version 20.00.00.00 (2014.09.18)
Copyright (c) 2008-2014 LSI Corporation. All rights reserved

Adapter Selected is a LSI SAS: SAS2008(B2)

Controller Number              : 0
 Controller                     : SAS2008(B2)
 PCI Address                    : 00:01:00:00
 SAS Address                    : SSSSSSSSSSSSSSSSSSSSSSSS <<<<<这里
 NVDATA Version (Default)       : 11.00.00.08
 NVDATA Version (Persistent)    : 11.00.00.08
 Firmware Product ID            : 0x2213 (IR)
 Firmware Version               : 19.00.00.00
 NVDATA Vendor                  : LSI
 NVDATA Product ID              : SAS9211-8i
 BIOS Version                   : 07.37.00.00
 UEFI BSD Version               : N/A
 FCODE Version                  : N/A
 Board Name                     : SAS9211-8i
 Board Assembly                 : AAAAAAAAAAAAAAAAAAAAAAA <<<<<这里
 Board Tracer Number            : TTTTTTTTTTTTTTTTTTTTTTT <<<<<还有这里

Finished Processing Commands Successfully.
Exiting SAS2Flash.

```

## 3）依次运行以下命令

```cmd

sas2flsh -o -e 6
sas2flsh -o -b mptsas2.rom
sas2flsh -o -f 2118it.bin

```

## 4）把备份的各种序列号写回去

```cmd

sas2flash -o -sasadd SSSSSSSSSSSSSSSSSSSSSSSS
sas2flash -o -assem AAAAAAAAAAAAAAAAAAAAAAA
sas2flash -o -tracer TTTTTTTTTTTTTTTTTTTTTTT

```

## 5）运行命令检查

```cmd

sas2flash -list

```

# EFI-SHELL下刷ROM

## 1) 确认你的主板支持 UEFI

## 2) 把以下文件放到硬盘的根目录下

```cmd

Installer_P20_for_UEFI.zip > sas2flash.efi
9211_8i_Package_P20_IR_IT_FW_BIOS_for_MSDOS_Windows.zip > Firmware\HBA_9211_8i_IT\2118it.bin
9211_8i_Package_P20_IR_IT_FW_BIOS_for_MSDOS_Windows.zip > sasbios_rel\mptsas2.rom

```

## 4) 启动 EFI SHELL（从主板启动，或从U盘启动）

## 5) 找到刷机的文件

* 用命令fxn改变驱动器，n是数字，表示驱动器号，从0开始，执行后用ls列出当前驱动器文件，如果没有就切换到下一个驱动器，fx1、fx2等到

```shell

fx0

```

## 6) 查看并备份序列号

```shell

sas2flash.efi -list

```

## 7) 刷固件

```shell

sas2flash.efi -o -e 6
sas2flash.efi -o -f 2118it.bin
sas2flash.efi -o -b mptsas2.rom

```

## 8) 写回序列号

```cmd

sas2flash.efi -o -sasadd SSSSSSSSSSSSSSSSSSSSSSSS
sas2flash.efi -o -assem AAAAAAAAAAAAAAAAAAAAAAA
sas2flash.efi -o -tracer TTTTTTTTTTTTTTTTTTTTTTT

```
