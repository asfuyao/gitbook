# 1. 删除软件包，并删除相应的配置文件

```shell
apt-get --purge remove nginx
```

# 2. 删除相关的依赖软件包

```shell
apt-get autoremove nginx
```

# 3. 罗列出与nginx相关的软件

```shell
dpkg --get-selections | grep nginx
```

# 4. 如果上面有返回相关软件，则同时相关软件的软件包，并删除相应的配置文件

```shell
apt-get --purge remove softname
```

# 5. 重新安装软件

```shell
apt-get install nginx
```
