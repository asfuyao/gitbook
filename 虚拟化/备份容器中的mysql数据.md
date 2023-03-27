# 创建备份脚本

mysqlbak.sh

```shell
#!/bin/sh

# 设置备份文件存放路径，这个路径是容器内的
bak_path=/var/lib/mysql/databak
# 设置保留多少天的备份
expire_day=120
# 时间变量，用于备份文件名
bak_time=`date +%Y%m%d%H%M%S`
# 获取命令行参数，数据库名
databasename=$1

username=用户名
password=密码

#mysqldump -u$username -p$password --databases $databasename > $bak_path/$databasename$bak_time.sql

# 备份指定数据到压缩文件
mysqldump -u$username -p$password --databases $databasename | gzip >> $bak_path/$databasename$bak_time.sql.gz

for bakfile in `find $bak_path/ -mtime +$expire_day -type f -name "*.sql.gz"`
do
  rm -f $bakfile
done

```

# 复制脚本到容器

```shell
sudo docker cp ./mysqlbak.sh 容器ID:/bin/mysqlbak.sh
```

# 执行备份脚本

```shell
sudo docker exec -it 容器ID /bin/sh /bin/mysqlbak.sh 数据库名
```
