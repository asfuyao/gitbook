# 0x80070020错误

## 端口问题分析

```powershell
# 查看端口是否被占用
netstat -ano | findstr 端口号
# 查看系统默认端口占用访问
netsh int ipv4 show dynamicport tcp
# 查看hyper-v启动后的保留端口范围
netsh interface ipv4 show excludedportrange protocol=tcp
```

## 解决办法

### 端口被占用

关闭占用端口的程序，或者修改项目端口

### 端口被保留

1. 由于直接进行第二步配置，会遇到程序占用(hyper-v占用)，所以需要先关闭hyper-v， 可以win+s 快捷键搜索 “windows功能” ，关闭hyper-v，或者使用下列命令，然后重启

```powershell
# powershell / cmd
dism.exe /Online /Disable-Feature:Microsoft-Hyper-V
```

2. 配置ipv4动态端口 /  或者配置需要的端口不被占用

```powershell
# powershell / cmd 管理员权限
# start 起始端口  num 表示可用端口数     按自己的需求来
netsh int ipv4 set dynamicport tcp start=30000 num=16383

# 排除ipv4动态端口占用 startport 起始端口 numberofports 端口数
netsh int ipv4 add excludedportrange protocol=tcp startport=50051 numberofports=1
```

3. 重启hyper-v，命令或配置窗口

```powershell
dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All
```
