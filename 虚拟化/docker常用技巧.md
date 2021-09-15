# 进入容器内部

```shell
docker exec -it 容器名 /bin/bash
```

# 安装容器管理工具

```shell
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

# daemon.json

```json
{
    "iptables": false, //在linux下设置，可以使ufw防火墙规则设置生效，否则dockers会自己添加iptables规则，ufw无法阻止
    "registry-mirrors": [
        "https://registry.docker-cn.com",
        "http://docker.mirrors.ustc.edu.cn"
    ] //设置仓库镜像
}
```
# 重启docker

```shell
# 守护进程重启
systemctl daemon-reload

# 重启docker服务
systemctl restart docker
service docker restart

```
