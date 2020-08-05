---
layout:     post
title:      CentOS7安装Oracle11g
subtitle:   Oracle
date:       2020-08-05
author:     Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:

    - Oracle
    - Database
    - Linux

---

> CentOS7安装Oracle11g

<!-- TOC -->

- [1. 全局设置](#1-全局设置)
- [2. 系统设置](#2-系统设置)
    - [2.1. 关闭selinux](#21-关闭selinux)
    - [2.2. 关闭防火墙](#22-关闭防火墙)
    - [2.3. 安装依赖包](#23-安装依赖包)
    - [2.4. 添加安装用户和用户组](#24-添加安装用户和用户组)
    - [2.5. 修改内核参数配置文件](#25-修改内核参数配置文件)
    - [2.6. 修改用户的限制文件](#26-修改用户的限制文件)
    - [2.7. 创建安装目录和设置文件权限](#27-创建安装目录和设置文件权限)
- [3. oracle安装](#3-oracle安装)
    - [3.1. 设置oracle用户环境变量](#31-设置oracle用户环境变量)
    - [3.2. 编辑静默安装响应文件](#32-编辑静默安装响应文件)
    - [3.3. 根据响应文件静默安装Oracle11g](#33-根据响应文件静默安装oracle11g)
    - [3.4. 执行管理员命令](#34-执行管理员命令)
- [4. oracle配置](#4-oracle配置)
    - [4.1. 以静默方式配置监听](#41-以静默方式配置监听)
    - [4.2. 以静默方式建立新库，同时也建立一个对应的实例](#42-以静默方式建立新库同时也建立一个对应的实例)
    - [4.3. 检查数据库状况](#43-检查数据库状况)
    - [4.4. 常见安装错误](#44-常见安装错误)
- [5. oracle删除](#5-oracle删除)

<!-- /TOC -->

# 1. 全局设置

* 安装程序解压缩后放在：/software/database
* oracle安装位置：/data/oracle
* 全局数据库名：orcl.test
* 系统标识符(SID)：orcl

# 2. 系统设置

## 2.1. 关闭selinux

编辑/etc/selinux/config文件`vim /etc/selinux/config`，设置：SELINUX=disabled

执行设置：`setenforce 0`

## 2.2. 关闭防火墙

关闭：`systemctl disable firewalld.service`

验证：`systemctl list-unit-files|grep firewalld.service`

## 2.3. 安装依赖包

```shell
yum -y install gcc make binutils gcc-c++ compat-libstdc++-33elfutils-libelf-devel elfutils-libelf-devel-static ksh libaio libaio-develnumactl-devel sysstat unixODBC unixODBC-devel pcre-devel
```

## 2.4. 添加安装用户和用户组

```shell
groupadd oinstall
groupadd dba
useradd -g oinstall -G dba oracle
passwd oracle
```

查看用户：`id oracle`

## 2.5. 修改内核参数配置文件

编辑文件/etc/sysctl.conf，命令：`vim /etc/sysctl.conf`

编辑/etc/sysctl.conf文件，在末尾添加下面内容：

```text
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmall = 2097152
kernel.shmmax = 1073741824
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
```

验证是否成功写进/etc/sysctl.conf文件中：`sysctl -p`

其中kernel.shmmax = 1073741824为本机物理内存（2G）的一半，单位为byte

## 2.6. 修改用户的限制文件

编辑文件/etc/security/limits.conf，命令：`vim /etc/security/limits.conf`

在末尾添加以下内容：

```text
oracle           soft    nproc           2047
oracle           hard    nproc           16384
oracle           soft    nofile          1024
oracle           hard    nofile          65536
oracle           soft    stack           10240
```

修改/etc/pam.d/login文件，命令：`vim /etc/pam.d/login`

在末尾添加以下内容：

```text
session required  /lib64/security/pam_limits.so
session required  pam_limits.so
```

修改/etc/profile文件，命令：`vim /etc/profile`

在末尾添加以下内容：

```text
# oracle config
if [ $USER = "oracle" ]; then
  if [ $SHELL = "/bin/ksh" ]; then
      ulimit -p 16384
      ulimit -n 65536
  else
      ulimit -u 16384 -n 65536
  fi
fi
```

## 2.7. 创建安装目录和设置文件权限

```shell
mkdir -p /data/oracle/product/11.2.0
mkdir /data/oracle/oradata
mkdir /data/oracle/inventory
mkdir /data/oracle/fast_recovery_area
chown -R oracle:oinstall /data/oracle
chmod -R 775 /data/oracle
```

# 3. oracle安装

## 3.1. 设置oracle用户环境变量

首先切换到oracle用户下：`su -l oracle`

编辑.bash_profile文件，命令：`vim .bash_profile`

在末尾添加如下内容：

```shell
ORACLE_BASE=/data/oracle
ORACLE_HOME=$ORACLE_BASE/product/11.2.0
ORACLE_SID=orcl
PATH=$PATH:$ORACLE_HOME/bin
export ORACLE_BASE ORACLE_HOME ORACLE_SID PATH
```

刷新设置：`source .bash_profile`

## 3.2. 编辑静默安装响应文件

复制安装文件夹response到当前oracle用户的家目录下：

```shell
cd
cp -R /software/database/response/ .
cd response/
vim db_install.rsp
```

需要设置的选项如下：

```text
oracle.install.option=INSTALL_DB_SWONLY
ORACLE_HOSTNAME=CentOS
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/data/oracle/inventory
SELECTED_LANGUAGES=en,zh_CN
ORACLE_HOME=/data/oracle/product/11.2.0
ORACLE_BASE=/data/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.DBA_GROUP=dba
oracle.install.db.OPER_GROUP=dba
DECLINE_SECURITY_UPDATES=true
```

## 3.3. 根据响应文件静默安装Oracle11g

```shell
cd /software/database/
./runInstaller -silent -responseFile /home/oracle/response/db_install.rsp -ignorePrereq
```

如果执行以上命令出错，会提示有参数格式，按照提示参数格式修改修改即可，一般是由于word中的字体、符号格式复制到客户端命令行后不一致引起，修改即可

如果遇到交换空间不足问题，需要增加交换空间，可以退出到root身份用下面命令：

```shell
dd if=/dev/zero of=swapfile bs=1024 count=500000
mkswap swapfile
swapon swapfile
```

开始Oracle在后台静默安装。安装过程中，如果提示[WARNING]不必理会，此时安装程序仍在后台进行，如果出现Successfully Setup Software，则安装程序已经停止了。

可以在以下位置找到本次安装会话的日志:/data/oracle/inventory/logs/installActions*.log

## 3.4. 执行管理员命令

安装完毕后会提示以root身份执行脚本，退出到root身份，执行脚本：

```shell
sh /data/oracle/inventory/orainstRoot.sh
sh /data/oracle/product/11.2.0/root.sh
```

# 4. oracle配置

## 4.1. 以静默方式配置监听

重新使用oracle用户登录：`su -l oracle`

配置监听：`netca /silent /responseFile /home/oracle/response/netca.rsp`

注意此处，必须使用/silent /responseFile格式，而不是-silent -responseFile，因为是静默安装。 

成功运行后，在/data/oracle/product/11.2.0/network/admin中生成listener.ora和sqlnet.ora 

通过netstat命令可以查看1521端口正在监听，安装netstat：`yum install net-tools`

## 4.2. 以静默方式建立新库，同时也建立一个对应的实例

`vim /home/oracle/response/dbca.rsp`修改文件中以下参数：

```shell
[GENERAL]

# oracle版本，不能更改
RESPONSEFILE_VERSION = "11.2.0"

# Description   : Type of operation
OPERATION_TYPE = "createDatabase"

[CREATEDATABASE]

# Description   : Global database name of the database
# 全局数据库的名字=SID+主机域名，第三方工具链接数据库的时候使用的service名称
GDBNAME = "orcl.test"

# Description   : System identifier (SID) of the database
# 对应的实例名字
SID = "orcl"

# Description   : Name of the template
# 建库用的模板文件
TEMPLATENAME = "General_Purpose.dbc"

# Description   : Password for SYS user
# SYS管理员密码
SYSPASSWORD = "123456"

# Description   : Password for SYSTEM user
# SYSTEM管理员密码
SYSTEMPASSWORD = "123456"

# Description   : Password for SYSMAN user
# SYSMAN管理员密码
SYSMANPASSWORD = "123456"

# Description   : Password for DBSNMP user
# DBSNMP管理员密码
DBSNMPPASSWORD = "123456"

# Description   : Location of the data file's
# 数据文件存放目录
DATAFILEDESTINATION =/data/oracle/oradata

# Description   : Location of the data file's
# 恢复数据存放目录
RECOVERYAREADESTINATION=/data/oracle/fast_recovery_area

# Description   : Character set of the database
# 字符集，重要!!! 建库后一般不能更改，所以建库前要确定清楚。
# (CHARACTERSET = "AL32UTF8" NATIONALCHARACTERSET= "UTF8")
CHARACTERSET = "ZHS16GBK"

# Description   : total memory in MB to allocate to Oracle
# oracle内存1638MB,物理内存2G*80%
TOTALMEMORY = "1638"
```

进行静默配置：`dbca -silent -responseFile /home/oracle/response/dbca.rsp`

有关详细信息, 请查看以下位置的日志文件: /data/oracle/cfgtoollogs/dbca/orcl/orcl.log

## 4.3. 检查数据库状况

建库后进行实例进程检查：`ps -ef | grep ora_ | grep -v grep`

查看监听状态：`lsnrctl status`

登录查看实例状态：`sqlplus / as sysdba`

```sql
select status from v$instance;
```
## 4.4. 常见安装错误

如果报错：【ORA-12162: TNS:net service name is incorrectly specified】

错误原因：【这个错误是因为ORACLE_SID变量没有传进去造成的。】

解决方法：

1．查看当前ORACLE_SID：`echo $ORACLE_SID`

orcl

2．修改ORACLE_SID和/home/oracle/response/dbca.rsp中的一样`export ORACLE_SID=orcl`

3．如果遇到ORA-12162: TNS:net service name is incorrectly specified.错误

参考文章：[ORA-12162: TNS:net service name is incorrectly specified.](https://www.cnblogs.com/mmzs/p/11162231.html)

4．如果依然不能登陆，尝试修改orcle文件夹的权限

【如果本地连接时，出现监听错误，[参考Linux中安装Oracle11g后出现监听的问题及解决办法](http://www.cnblogs.com/mmzs/p/9043767.html)】

# 5. oracle删除

## 首先查看dbca的帮助信息

```shell
dbca -help
```

修改/home/oracle/response/dbca.rsp文件里以下几个参数，下面三个参数根据建库实际情况进行修改：

```text
OPERATION_TYPE = "deleteDatabase"
SOURCEDB = "orcl"
SYSDBAUSERNAME = "sys"
SYSDBAPASSWORD = "123456"
```

然后运行：`dbca -silent -responseFile /home/oracle/response/dbca.rsp`

各参数含义如下:

-silent 表示以静默方式删除

-responseFile 表示使用哪个响应文件,必需使用绝对路径

RESPONSEFILE_VERSION 响应文件模板的版本,该参数不要更改

OPERATION_TYPE 安装类型,该参数不要更改

SOURCEDB 数据库名,不是全局数据库名,即不包含db_domain

很简单数据库卸载完成了，请注意，只是数据库卸载完了，数据库软件还是在的。


## 使用DBCA卸载数据库

```shell
dbca -silent -delete Database -responseFile dbca.rsp
```

a.选项-silent表示静默安装，免安装交互，大部分安装信息也不输出

b.选项-responseFile指定应答文件，要求用绝对路径
