# Temporary ASP.NET Files 的写访问权限问题

搭建IIS项目，访问的时候出现如下所示的错误：

```shell
# 64位
当前标识(IIS APPPOOL\XXXX)没有对“C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files”的写访问权限

# 32位
当前标识(IIS APPPOOL\XXXX)没有对“C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files”的写访问权限
```

解决办法：管理员权限进入powershell，执行下面命令

```shell
# 64位
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Aspnet_regiis.exe -ga 'IIS APPPOOL\XXXX'

# 32位
C:\Windows\Microsoft.NET\Framework\v4.0.30319\Aspnet_regiis.exe -ga 'IIS APPPOOL\XXXX'
```
