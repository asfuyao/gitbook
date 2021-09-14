<!-- TOC -->

- [1. 在客户端生产ssh-key](#1-在客户端生产ssh-key)
- [2. 上传公钥并设置权限](#2-上传公钥并设置权限)
- [3. 修改sshd配置](#3-修改sshd配置)
- [4. 客户端使用私钥登录](#4-客户端使用私钥登录)

<!-- /TOC -->

# 1. 在客户端生产ssh-key

```shell
ssh-keygen -t rsa -C "name"
```

* passphrase 是证书口令，以加强安全性，避免证书被恶意复制
* 会在~.ssh下生成id_rsa，id_rsa.pub两个文件，分别是私钥和公钥

# 2. 上传公钥并设置权限

* 公钥id_rsa.pub需保存到远程服务器~/.ssh目录下，并重命名为authorized_keys
* 要保证目录.ssh和文件authorized_keys都只有用户自己有写权限，否则验证无效。

```shell
chmod -R 700 ~/.ssh/
chmod 600 ~/.ssh/authorized_keys
```

# 3. 修改sshd配置

编辑/etc/ssh/sshd_config文件

```shell

PermitRootLogin no  #禁用root账户登录
StrictModes yes #是否让sshd去检查用户家目录或相关档案的权限是否正确
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile %h/.ssh/authorized_keys
PasswordAuthentication no #禁用密码登录
```

# 4. 客户端使用私钥登录


```shell
# 使用私钥登录
ssh username@hostname -i ~/.ssh/id_rsa
```
