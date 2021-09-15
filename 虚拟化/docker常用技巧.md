# 进入容器内部

```shell
docker exec -it 容器名 /bin/bash
```

# 安装容器管理工具

```shell
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```
