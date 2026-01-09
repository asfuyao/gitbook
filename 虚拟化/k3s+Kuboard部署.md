# debian12下的部署教程

## K3s

### 1. 更新系统包

首先，更新系统包以确保系统处于最新状态：

```bash
sudo apt update -y
sudo apt upgrade -y
```

### 2. 安装 K3s

#### 标准安装

需科学上网

```shell
curl -sfL https://get.k3s.io | sh - 
```

多网卡指定主网卡

```shell
curl -sfL https://get.k3s.io | sh -s - server --flannel-iface=网卡名 --node-ip=IP地址
```

#### 国内源安装

K3s 提供了一个安装脚本，可以通过设置环境变量 `INSTALL_K3S_MIRROR=cn` 来使用国内镜像源。运行以下命令安装 K3s，为了确保 K3s 使用国内镜像仓库，可以指定 `--system-default-registry` 参数。例如，使用阿里云的镜像仓库：

```bash
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | \
INSTALL_K3S_MIRROR=cn \
sh -s - --system-default-registry=registry.cn-hangzhou.aliyuncs.com

curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -
# 基于docker安装，ubuntu24.04下测试只能使用docker，用contained不好用
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -s - --docker
```

### 3. 验证 K3s 安装

安装完成后，可以通过以下命令验证 K3s 是否正常运行：

```bash
systemctl status k3s
```

如果服务正常运行，输出中应显示 `active (running)` 状态。

### 4. 配置 K3s Agent 节点（可选）

如果需要在其他节点上安装 K3s Agent，可以使用以下命令：

```bash
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | \
INSTALL_K3S_MIRROR=cn \
K3S_URL=https://<master-ip>:6443 \
K3S_TOKEN=<token> \
sh -


 curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.106:6443 K3S_TOKEN=K10a12d951b6ff5259f7b3d60871ac4858d005bdf8f1c2b358095ed58c3f927b9a2::server:3cd2d63d57987d18e6bfae8f76cfdd53 INSTALL_K3S_EXEC="--node-ip=192.168.1.107 --flannel-iface=enp6s19" sh -

```

其中 `<master-ip>` 是主节点的 IP 地址，`<token>` 是主节点的 K3s token，可以通过 `sudo cat /var/lib/rancher/k3s/server/node-token` 获取。

### 5. 配置镜像代理（可选）

如果需要进一步优化镜像拉取速度，可以配置 K3s 使用国内镜像代理。编辑 `/etc/rancher/k3s/registries.yaml` 文件：

```yaml
mirrors:
  "docker.io":
    endpoint:
      - "https://registry.cn-hangzhou.aliyuncs.com"
```

然后重启 K3s 服务：

```bash
sudo systemctl restart k3s
```

通过以上步骤，您可以在 Debian 12 上使用国内源快速部署 K3s。

## Kuboard

### 1. 在线安装

```bash
kubectl apply -f https://addons.kuboard.cn/kuboard/kuboard-v3.yaml
# 您也可以使用下面的指令，唯一的区别是，该指令使用华为云的镜像仓库替代 docker hub 分发 Kuboard 所需要的镜像
# kubectl apply -f https://addons.kuboard.cn/kuboard/kuboard-v3-swr.yaml


# 基于docker安装
docker run -d \
  --restart=unless-stopped \
  --privileged \
  --name=kuboard \
  -p 8088:80/tcp \
  -p 10081:10081/tcp \
  -e KUBOARD_ENDPOINT="http://主机IP:8088" \
  -e KUBOARD_AGENT_SERVER_TCP_PORT="10081" \
  -v /root/kuboard-data:/data \
  eipwork/kuboard:v3
```

如果您想要定制 Kuboard 的启动参数，请将该 YAML 文件下载到本地，并修改其中的 ConfigMap

### 2. 等待 Kuboard v3 就绪

执行指令 `watch kubectl get pods -n kuboard`，等待 kuboard 名称空间中所有的 Pod 就绪，如下所示，

如果结果中没有出现 `kuboard-etcd-xxxxx` 的容器，请查看 常见错误 中关于 `缺少 Master Role` 的描述。

```sh
[root@node1 ~]# kubectl get pods -n kuboard
NAME                               READY   STATUS    RESTARTS   AGE
kuboard-agent-2-65bc84c86c-r7tc4   1/1     Running   2          28s
kuboard-agent-78d594567-cgfp4      1/1     Running   2          28s
kuboard-etcd-fh9rp                 1/1     Running   0          67s
kuboard-etcd-nrtkr                 1/1     Running   0          67s
kuboard-etcd-ader3                 1/1     Running   0          67s
kuboard-v3-645bdffbf6-sbdxb        1/1     Running   0          67s    
```

### 3. 访问 Kuboard

- 在浏览器中打开链接 `http://your-node-ip-address:30080`
- 输入初始用户名和密码，并登录
  - 用户名： `admin`
  - 密码： `Kuboard123`

## Portainer

另一个管理工具，功能比Kuboard弱，只有英文，安装后访问http://主机IP:30777

```shell
kubectl apply -n portainer -f https://downloads.portainer.io/ce-lts/portainer.yaml
```



## 配置镜像下载加速

/etc/rancher/k3s/registries.yaml

```yaml
mirrors:
  docker.io:
    endpoint:
      - "https://docker.xuanyuan.me" #此处可用其他加速地址替代
```

添加私有仓库：

```yaml
mirrors:
  "docker.io":
    endpoint:
      - "https://docker.xuanyuan.me"

configs:
  "erpdev.top:20085":
    auth:
      username: admin
      password: P@ssw0rd
    tls: {}
```



重启服务：`sudo systemctl restart k3s`

## 常用操作

```bash
# 拉取镜像
sudo k3s crictl pull <repository>/<image>:<tag>
# 查看下载的镜像
sudo k3s crictl images
# 查看容器
crictl ps
# 查看容器详细信息
crictl inspect <container-id>
# 列出所有Pod
crictl pods
# 查看pod详细信息
crictl inspectp <pod-id>
# 查看日志
crictl logs <container-id>
# 执行命令
crictl exec -i -t <container-id> <command>
crictl exec -i -t <container-id> /bin/sh
```

