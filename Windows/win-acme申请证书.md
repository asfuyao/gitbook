# 证书申请

## 准备环境

### win-acme

win-acme官网：https://www.win-acme.com/

下载后的文件实例：

* win-acme.v2.2.9.1701.x64.pluggable.zip，主程序
* plugin.validation.dns.aliyun.v2.2.9.1701.zip，阿里云dns验证插件，其他服务商请上https://www.win-acme.com/reference/plugins/validation/dns/查找并下载

解压缩后将2个压缩包内的文件放到同一个目录中

### 阿里云的key

1️⃣ 登录阿里云控制台
浏览器打开 [https://account.aliyun.com](https://account.aliyun.com/) → 用阿里云主账号扫码或密码登录。

2️⃣ 进入 RAM 访问控制
• 控制台首页右上角头像 → **访问控制**

3️⃣ 创建 RAM 子用户（推荐）
• 左侧菜单 **身份管理 → 用户 → 创建用户**。
• 填写“登录名称”如 `dns-auto`，显示名“Let’s Encrypt DNS”。
• **勾选 “使用永久 AccessKey 访问”** → 确定。
• 创建成功后页面会一次性显示
**AccessKey ID** 与 **AccessKey Secret** → 立即复制保存（Secret 只出现一次）。

4️⃣ 给子用户授权（最小权限）
• 在该用户详情页 → **权限管理 → 新增授权**。
• 选择系统策略 **AliyunDNSFullAccess**（或自定义策略，仅允许对域名 `erpdev.top` 的 TXT 记录写权限）。
• 保存即可。

5️⃣ 安全加固（可选但强烈建议）
• 仍在用户详情 → **安全设置** → 配置 **IP 白名单**，限制仅你的服务器出口 IP 可调用。
• 定期轮换密钥：重复 3️⃣ 创建新密钥 → 旧密钥停用 → 在 win-acme 里更新。

## 执行命令申请证书

### dns验证

* 需要修改配置文件settings.json，将PreValidateDns对应行修改为："PreValidateDns": false

```shell
wacs.exe --source manual --host *.域名,域名 --validation aliyun --aliyunapiid [AccessKey ID] --aliyunapisecret [AccessKey Secret] --store pemfiles --pemfilespath "存储证书文件的路径" --installation none --accepttos
```

### 自主机验证

* 需要外网可以访问80端口
* 需要管理员权限启动
* 域名不能用通配符，每次只能申请一个域名
* 每次申请一个不同的域名后，会

```shell
wacs.exe --target manual --host otdinfo.com --validation selfhosting --store pemfiles --pemfilespath "D:\Software\win-acme\ssl" --installation none --accepttos
```

**注：如果是1天以内重新申请需要加上参数：--nocache**

## 缓存和配置

win-acme 把所有“缓存+配置+日志”统一放在
**`C:\ProgramData\win-acme`**
（`%ProgramData%\win-acme` 的绝对路径，默认隐藏，需“显示隐藏项目”才能看到）。

目录结构：

```
C:\ProgramData\win-acme
└─ acme-v02.api.letsencrypt.org\
   ├─ settings.json        ← 全局配置，可改日志级别/路径/续期阈值等
   ├─ secrets.json         ← 加密的 DNS API 密钥、SMTP 密码等
   ├─ Renewals\            ← 每张证书的续期 JSON 任务文件
   ├─ Certificates\        ← 已下载的 .pfx/.pem 证书缓存
   ├─ Orders\              ← 订单与 CSR 缓存
   ├─ Log\                 ← 当天及历史日志（*.log）
   └─ .validation-cache\   ← HTTP-01 临时验证文件（很少用）
```

如需备份或迁移，把整个 `C:\ProgramData\win-acme` 打包即可；重装系统后放回原路径即可继承所有证书与任务。

## 证书更新

### 自动更新

* 证书创建成功后会在windows的计划任务中创建一条计划任务，每天9点自动执行刷新任务

### 手动更新

* 手动执行刷新的命令：wacs.exe --renew，执行后会刷新所有证书
