# 1. 下载并安装ODBC驱动

驱动下载地址：http://dev.mysql.com/downloads/connector/odbc/

# 2. 配置ODBC系统DSN

* 管理工具 -> ODBC数据源 -> 系统DSN -> 添加
* 选择 MySQL ODBC 8.0 Unicode Driver
* 填写服务器地址、用户名、密码、默认数据库等信息

# 3. 配置链接服务器

* SSMS -> 服务器对象 -> 链接服务器 -> 新建链接服务器
* 常规：其他数据源，选择：Microsoft OLE DB Provider for ODBC Drivers
* 常规：产品名称，填写：MYSQL_DBLINK
* 常规：数据源，填写刚刚创建的ODBC系统DSN名称
* 安全性：选择使用此安全上下文建立连接，填写登录用户和密码

# 4. 使用方法

```sql
–查询
SELECT * FROM OPENQUERY(链接服务器名, ‘select * from tableName where id=”1”’)

–修改
UPDATE OPENQUERY(链接服务器名, ‘select * from tableName where id=”1”’) set cname=’测试’
–or
UPDATE OPENQUERY(链接服务器名, ‘select * from tableName ‘) set cname=’测试’ where id=1

–添加
INSERT INTO OPENQUERY(链接服务器名, ‘select * from tableName where 1=0’)values (‘xx’,’xx’,’xx’);

–删除
DELETE FROM OPENQUERY(链接服务器名, ‘select * from tableName where id=”1”’)
```
