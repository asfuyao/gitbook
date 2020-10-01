# 通过脚本修改网卡的IP设置

```cmd
@echo off

rem 设置网络适配器名
set eth="LAN"
rem IP地址，动态ip填写为dhcp，如设置为dhcp下面的子网掩码和网关设置不生效
set ip=dhcp
rem 子网掩码
set netmask=
rem 网关，空值为none
set gw=none
rem 首选DNS，空值为none，动态分配为dhcp
set dns1=dhcp
rem 备用DNS，空值为none，如dns1为dhcp此处请设置为none
set dns2=none

echo 设置连接%eth%的IP地址为：%ip%
if %ip%==dhcp (netsh interface ipv4 set address %eth% source=dhcp) else (netsh interface ipv4 set address %eth% static %ip% %netmask% %gw% 1)

echo 清理DNS服务器设置
netsh interface ipv4 delete dnsservers %eth% all >nul

if not %dns1%==none (echo 正在设置首选DNS服务器 %dns1%)
if not %dns1%==none (if %dns1%==dhcp (netsh interface ipv4 set dnsservers %eth% source=dhcp) else (netsh interface ipv4 set dnsservers %eth% static %dns1% primary))

if not %dns2%==none (echo 正在设置备用DNS服务器 %dns2%)
if not %dns2%==none (netsh interface ipv4 add dnsservers %eth% %dns2% index=2)

netsh interface ipv4 show config %eth%
set choice=
set /p choice=IP地址切换完毕，按任回车键退出
echo.
```
