# 1. 通过docker部署sqlserver安装在容器外

## 1.1. 安装sqlserver2019

操作系统：CentOS8，可替代产品：AlmaLinux8

### 1.1.1. 安装

```shell
# 添加仓库
sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/8/mssql-server-2019.repo
# 安装mssql2019
sudo yum install -y mssql-server
# 打开防火墙端口1433
sudo firewall-cmd --zone=public --add-port=1433/tcp --permanent
sudo firewall-cmd --reload
```

### 1.1.2. 初始化

```shell
# 初始化，根据实际情况修改
sudo ACCEPT_EULA='Y' MSSQL_PID='Enterprise' MSSQL_SA_PASSWORD='P@ssw0rd' MSSQL_DATA_DIR='/uniworks/database' MSSQL_BACKUP_DIR='/uniworks/databak' MSSQL_LCID='2052' MSSQL_COLLATION='Chinese_PRC_CI_AS' TZ='Asia/Shanghai' MSSQL_AGENT_ENABLED='True' /opt/mssql/bin/mssql-conf setup

# 设置用户反馈
sudo /opt/mssql/bin/mssql-conf set telemetry.customerfeedback false

# 重启服务
sudo systemctl start mssql-server

# 安装sql-tools（可选）
curl https://packages.microsoft.com/config/rhel/8/prod.repo | sudo tee /etc/yum.repos.d/mssql-release.repo
sudo yum install -y mssql-tools18 unixODBC-devel
```

## 1.2. 安装1panel管理面板

```shell
# 一键安装docker
bash <(curl -sSL https://linuxmirrors.cn/docker.sh)

# 安装1panel
curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
```

安装后进入面板，设置docker加速为：https://docker.1panel.live

## 1.3. 配置容器的注意事项

* webapi的服务端口可用设置为：127.0.0.1:端口，避免对外开放端口
* 配置网站的反向代理可用127.0.0.1:端口来访问webapi服务
* 反向代理配置时，清空匹配规则，在proxy_pass前面添加一行：rewrite /api/路径/(.*) /$1 break;

# 部署在k3s中

## 部署k3s

部署后通过http://ip:300080访问，使用默认的用户名 admin 和密码 Kuboard123 登录

```shell
# 安装k3s
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -

# 查看服务状态
k3s kubectl get nodes

# 配置镜像加速
cat >> /etc/rancher/k3s/registries.yaml <<EOF
mirrors:
  docker.io:
    endpoint:
      - "https://docker.1panel.live"
EOF

# 重启k3s
systemctl restart k3s

# 安装管理面板
kubectl apply -f https://addons.kuboard.cn/kuboard/kuboard-v3.yaml

# 查看面板安装进度
watch kubectl get pods -n kuboard

```

## 注意事项

* webapi容器的配置文件appsettings.json中绑定端口设置不能用localhost，要用*：端口号，否则无法访问
* 容器服务的访问可用通过ClusterIP加容器内端口
* webapi容器配置服务时，可用选用ClusterIP，不对外暴露端口