# 证书生成

## 查看openssl

```shell
# 首先查看系统是否已经安装openssl
openssl version -a

# 查看openssl配置
vi /etc/ssl/openssl.cnf
```

## 生成证书

```shell
# 1. 生成根证书的私钥（CA证书的RSA密钥，PEM格式)，会提示输入密码，输入两次相同密码即可，生成文件：server.key
openssl genrsa -des3 -out server.key 2048

# 2. 可选操作：openssl调用此文件会经常要求输入密码，如果想去除此输密码的步骤，可以执行命令：
openssl rsa -in server.key -out server.key

# 3. 生成证书签署请求创建服务器证书的申请文件，会要求输入一堆内容根据实际情况填写即可（随便填也行），生成文件：server.csr
openssl req -new -key server.key -out server.csr

# 4. 生成自签证书，即根证书CA（有效期为十年的），此文件可用来给自己的证书签名，生成文件：ca.crt
openssl req -new -x509 -key server.key -out ca.crt -days 3650

# 5. 创建服务器证书（有效期十年），生成文件：ca.srl，server.crt
openssl x509 -req -days 3650 -in server.csr -CA ca.crt -CAkey server.key -CAcreateserial -out server.crt

# 至此，共存在五个文件：server.key，server.csr，ca.srl，ca.crt，server.crt
```

## Nginx配置https（默认443端口）

```conf
server {
    listen 443;
    server_name localhost;  #这里可以填IP或者域名
    ssl on;
    ssl_certificate /root/keys/server.crt;     #配置证书位置
    ssl_certificate_key /root/keys/server.key; #配置秘钥位置】
    
    #ssl_client_certificate ca.crt;#双向认证
    #ssl_verify_client on; #双向认证
    
    ssl_session_timeout 5m;
    ssl_protocols SSLv2 SSLv3 TLSv1;
    ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
    ssl_prefer_server_ciphers on;
```
