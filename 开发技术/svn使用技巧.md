<!-- TOC -->

- [1. 设置global-ignores](#1-设置global-ignores)
    - [1.1. 配置文件](#11-配置文件)
    - [1.2. TortoiseSVN设置](#12-tortoisesvn设置)

<!-- /TOC -->

# 1. 设置global-ignores

Windows下有两种设置方式，下面按优先级从大到小列出

## 1.1. 配置文件

配置文件位置：C:\Users\{you}\AppData\Roaming\Subversion\config，编辑添加下面行

```ini
global-ignores = [Bb]in *obj *suo *resharp* *.user *.tmp *.TMP *Resharper* *.vs *packages *dist
```

## 1.2. TortoiseSVN设置

鼠标右键菜单Settings -> General -> Subversion -> Global ignore pattern: 追加下面字符串

```text
[Bb]in *obj *suo *resharp* *.user *.tmp *.TMP *Resharper* *.vs *packages *dist
```
