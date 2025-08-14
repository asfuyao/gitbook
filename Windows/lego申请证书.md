# 证书申请

## 准备环境

### lego

lego官网：https://github.com/go-acme/lego/releases

下载后的文件实例：lego_v4.25.2_windows_amd64.zip

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
• 定期轮换密钥：重复 3️⃣ 创建新密钥 → 旧密钥停用 → 在 lego 里更新。

## 执行命令申请证书

### dns验证

* 需要编写一个批处理，然后执行批处理即可

```shell
@echo off
set ALICLOUD_ACCESS_KEY=************
set ALICLOUD_SECRET_KEY=************
.\lego --email "you@example.com" --domains="example.com" --dns alidns run
```

### 自主机验证

* 需要外网可以访问80端口
* 需要管理员权限启动

```shell
lego --email="you@example.com" --domains="example.com" --http run
```

* 80端口被占用
* 在 Nginx 配置里加一段转发

```nginx
server {
    listen 80;
    server_name otdinfo.com;

    location /.well-known/acme-challenge/ {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
    }
}
```

* 重新加载配置nginx -s reload
* 启动lego时增加端口配置

```shell
lego --email="you@example.com" --domains="example.com" --http --http.port :8080 run
```



## 缓存和配置

lego 把所有”缓存+配置+日志“放在当前目录下的.lego目录中

## 证书更新

### 自动更新

* 

### 手动更新

* 手动执行刷新的命令：上面的命令后的run替换为renew即可，执行后会刷新所有证书
