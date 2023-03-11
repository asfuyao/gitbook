# docker部署

查考网站：https://github.com/haxqer/jira

## 创建docker-compose.yml

```yaml
version: '3.4'
services:
  jira:
    image: haxqer/jira:9.6.0
    container_name: jira-srv
    environment:
      - TZ=Asia/Shanghai
#      - JVM_MINIMUM_MEMORY=1g
#      - JVM_MAXIMUM_MEMORY=12g
#      - JVM_CODE_CACHE_ARGS='-XX:InitialCodeCacheSize=1g -XX:ReservedCodeCacheSize=8g'
    depends_on:
      - mysql
    ports:
      - "3087:8080"
    volumes:
      - ./jira_data:/var/jira
    restart: always
    networks:
      - network-bridge

  mysql:
    image: mysql:8
    container_name: mysql-jira
    environment:
      - TZ=Asia/Shanghai
      - MYSQL_DATABASE=jira
      - MYSQL_ROOT_PASSWORD=123456
      - MYSQL_USER=jira
      - MYSQL_PASSWORD=123123
    command: ['mysqld', '--character-set-server=utf8mb4', '--collation-server=utf8mb4_bin']
#    ports:
#      - "13306:3306"
    volumes:
      - ./mysql_data:/var/lib/mysql
    restart: always
    networks:
      - network-bridge

networks:
  network-bridge:
    driver: bridge

```

## 创建用户

```shell
sudo groupadd -g 999 jira
sudo useradd -u 999 -g jira jira
sudo usermod -s /sbin/nologin jira
```

## 启动容器

```shell
docker-compose up -d
# 启动后后创建jira_data文件夹，但此时该目录的权限属于root需要修改一下
sudo chown -R jira jira_data
sudo chgrp -R jira jira_data
# 再来重启一下jira容器
docker container restart jira-srv
```

# jira初始化

## 配置数据库连接

```
driver=mysql8.0
host=mysql-jira
port=3306
db=jira
user=root
passwd=123456
```

## 生成许可

记录下服务器 ID，例如：B7GO-J6A4-EJ6N-62VF

```shell
docker exec jira-srv java -jar /var/agent/atlassian-agent.jar \
    -p jira \
    -m asfuyao@qq.com \
    -n asfuyao@qq.com \
    -o http://website \
    -s B7GO-J6A4-EJ6N-62VF
```

# jira插件许可生成

安装插件后查看App Key，例如：BigGantt 插件是：eu.softwareplant.biggantt，然后执行：

```shell
docker exec jira-srv java -jar /var/agent/atlassian-agent.jar \
    -p eu.softwareplant.biggantt \
    -m asfuyao@qq.com \
    -n asfuyao@qq.com \
    -o http://website \
    -s B7GO-J6A4-EJ6N-62VF
```

