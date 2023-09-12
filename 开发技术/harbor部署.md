# 部署

## 下载离线安装包

地址：https://github.com/goharbor/harbor/releases

## 解压

```shell
cd /docker
tar xzvf harbor-offline-installer-vx.x.x.tgz
cd harbor
vim harbor.yml
```

## 配置

```yml
hostname: 192.168.1.2

http:
  port: 8085

https:
  port: 443
  certificate: /docker/harbor/ssl/server.crt
  private_key: /docker/harbor/ssl/server.key

harbor_admin_password: P@ssw0rd

database:
  password: root123
  max_idle_conns: 100
  max_open_conns: 900
  conn_max_lifetime: 5m
  conn_max_idle_time: 0

data_volume: /docker/harbor/data

trivy:
  ignore_unfixed: false
  skip_update: false
  offline_scan: false
  security_check: vuln
  insecure: false

jobservice:
  max_job_workers: 10

notification:
  webhook_job_max_retry: 10

chart:
  absolute_url: disabled

log:
  level: info
  local:
    rotate_count: 50
    rotate_size: 200M
    location: /docker/harbor/log

_version: 2.7.0

proxy:
  http_proxy:
  https_proxy:
  no_proxy:
  components:
    - core
    - jobservice
    - trivy

upload_purging:
  enabled: true
  age: 168h
  interval: 24h
  dryrun: false

cache:
  enabled: false
  expire_hours: 24
```

## 安装

```shell
sudo ./install.sh
```

## 开机自动运行

创建文件：/etc/systemd/system/harbor.service
文件内容：

```shell
[Unit]
Description=harbor
After=docker.service systemd-networkd.service systemd-resolved.service
Requires=docker.service
Documentation=http://github.com/vmware/harbor

[Service]
Type=simple
Restart=on-failure
RestartSec=5
ExecStart=/usr/bin/docker-compose -f  /docker/harbor/docker-compose.yml up
ExecStop=/usr/bin/docker-compose -f  /docker/harbor/docker-compose.yml down

[Install]
WantedBy=multi-user.target
```

创建完文件运行：

```shell
sudo systemctl enable harbor.service
```
