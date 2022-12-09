# 跳过证书提示

编辑~/.subversion/servers

```text
[global]
ssl-authority-files = /home/username/.subversion/cacert-svn.pem
ssl-ignore-host-mismatch = true
ssl-ignore-unknown-ca = true
ssl-ignore-invalid-date = true 
```

生成文件

```shell
cd /home/username/.subversion
openssl s_client -showcerts -connect bestsoftware.f3322.net:8883 < /dev/null > cacert-svn.pem
```

