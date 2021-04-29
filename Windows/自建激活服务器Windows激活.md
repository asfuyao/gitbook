# 搭建激活服务器

通过docker启动激活服务

```sh
docker run -d -p 1688:1688 --restart=always --name vlmcsd mikolatero/vlmcsd
```

KMS 方式激活，其有效期只有 180 天。每隔一段时间系统会自动向 KMS 服务器请求续期，请确保你自己的 KMS 服务正常运行

# Windows激活步骤

* 使用管理员权限运行cmd
* 查看系统版本：wmic os get caption
* 安装从上面列表得到的key：slmgr /ipk xxxxx-xxxxx-xxxxx-xxxxx-xxxxx
* KMS 服务器地址设置为你自己的IP或域名：slmgr /skms Your IP or Domain:1688
* 手动激活系统：slmgr /ato

激活Key可以到下面网址查询：
https://github.com/MicrosoftDocs/windowsserverdocs/blob/master/WindowsServerDocs/get-started/KMSclientkeys.md

# Office激活步骤

* 进入Office安装目录，例如：cd "C:\Program Files\Microsoft Office\Office16"
* 设置激活服务器地址：cscript ospp.vbs /sethst:Your IP or Domain
* 激活：cscript ospp.vbs /act
