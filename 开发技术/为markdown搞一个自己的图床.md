# Typora + PicGo + Github



## Github设置

### 创建存放图片的仓库

创建一个存放图片的仓库，类型一定要选Public的才可以通过外部访问图片，创建时选择添加README文件

![image-20220413162020004](https://cdn.jsdelivr.net/gh/asfuyao/MyImages@main/images/image-20220413162020004.png)



### 创建token

点击右上角头像，然后进入设置：Settings -> Developer settings -> Personal access tokens，创建新的token

scopes选择：repo

## Lsky Pro图床

### Docker部署

```yaml
version: '3'
services:
  lskypro:
    image: wbsu2003/lskypro
    restart: unless-stopped
    hostname: lskypro
    container_name: lskypro
    volumes:
      - ./data/lsky:/var/www/html
    ports:
      - "1689:80"
    networks:
      - lsky-net

  mysql-lsky:
    image: mysql:5.7.22
    restart: unless-stopped
    # 主机名，可作为子网域名填入安装引导当中
    hostname: lskypro-mysql
    # 容器名称
    container_name: lskypro-mysql
    # 修改加密规则
    command: --default-authentication-plugin=mysql_native_password
    volumes:
      - ./data/mysql/data:/var/lib/mysql
      - ./data/mysql/conf:/etc/mysql
      - ./data/mysql/log:/var/log/mysql
    environment:
      MYSQL_ROOT_PASSWORD: 1q2w3e4r # 数据库root用户密码
      MYSQL_DATABASE: lsky-data # 给lsky-pro用的数据库名称
    networks:
      - lsky-net

networks:
  lsky-net:
```

### 初始化

* mysql服务器：lskypro-mysql
* mysql数据库名：lsky-data
* mysql密码：1q2w3e4r
* 设置管理员账号和密码

## PicGo 客户端配置

git地址：[PicGo](https://github.com/Molunerfinn/PicGo)，下载最新版安装

### 设置Github图床

* 仓库名：github用户名/仓库名
* 分支名：main
* Token：刚刚创建的token
* 存储路径：images/
* 域名:  https://cdn.jsdelivr.net/gh/github用户名/仓库名@main

## 设置Typora

选择PicGo路径

![image-20220413163435692](https://cdn.jsdelivr.net/gh/asfuyao/MyImages@main/images/image-20220413163435692.png)
