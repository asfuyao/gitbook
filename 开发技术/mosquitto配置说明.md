# Windows环境部署

官方网站：https://mosquitto.org/

下载地址：https://mosquitto.org/download/

安装路径：任意英文路径（不包含空格）

安装选项：不安装服务

# 配置说明

## mosquitto.conf

```sh
# 监听端口号
listener 1885
# 协议
protocol mqtt
# 是否持久化
persistence true
# 持久化存储路径
persistence_location persistence
# 控制台日志输出
log_dest stdout 
# 文件日志输出
log_dest file mosquitto.log
# 日志类型，生产环境下应设置为error
log_type all
# 是否记录连接和断开的信息
connection_messages true
# 日志是否记录时间戳
log_timestamp true
# 日志格式
log_timestamp_format %Y-%m-%d %H:%M:%S
# 是否允许匿名访问
allow_anonymous false
# 设置每10秒钟更新一次系统主题
sys_interval 10
# 用户口令文件，存放用户名和用户密码，用来连接MQTT
password_file pwfile
# 权限控制文件，设置用户访问权限
acl_file aclfile
```

## mosquitto_passwd命令

```sh
# 创建一个新的口令文件，如果文件存在则将被覆盖
./mosquitto_passwd -c pwfile
# 创建一个新的口令文件，同时创建一个用户，命令输入完成后会提示输入密码
./mosquitto_passwd -c pwfile username
# 在已存在的口令文件中创建用户，如果用户已经存在会则密码会改为本次输入的密码
./mosquitto_passwd pwfile username
# 批处理模式在已存在的口令文件中创建用户和密码，不提示密码输入
./mosquitto_passwd -b pwfile username password
# 删除一个用户
./mosquitto_passwd -D pwfile username
```

## 权限控制文件格式说明

```sh
# 用户test权限：发布以test/开头的主题、订阅已test开头的主题、订阅$SYS/开头的系统主题
user test
topic write test/#
topic read test/#
topic read $SYS/#
```

# 启动程序

编写批处理文件

```she
# Windows下的批处理文件内容
@echo off
set MosquittoHome=D:\Server\mosquitto
%MosquittoHome%\mosquitto.exe -c %MosquittoHome%\mosquitto.conf -v
```

# 连接测试

```sh
# 订阅test/开头的主题
./mosquitto_sub -h 39.99.202.122 -p 51885 -u test -P test -v -t test/#

# 向test/1001主题发布一条json格式的数据
./mosquitto_pub.exe -h 39.99.202.122 -p 51885 -u test -P test -t test/1001 -m '{\"OnLineTime\":\"2021-05-05 08:00:00\"}'

# 订阅系统主题
./mosquitto_sub.exe -h 39.99.202.122 -p 51885 -u test -P test -t '$SYS/broker/connection/'
```

