# 部署说明

## 安装AlmaLinux

下载地址：https://mirrors.aliyun.com/almalinux/8.6/isos/x86_64/

下载文件：AlmaLinux-8.6-x86_64-minimal.iso

下载后安装，选择最小安装

## 更换国内源

阿里云镜像站点，参考网址：https://developer.aliyun.com/mirror/almalinux

```shell
sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^# baseurl=https://repo.almalinux.org|baseurl=https://mirrors.aliyun.com|g' \
    -i.bak \
    /etc/yum.repos.d/almalinux*.repo
```

## 更新系统

```shell
yum update -y

reboot
```

## 安装常用软件

```shell
yum install epel-release -y
yum install vim screen -y
echo alias vi=\'vim\' >> ~/.bashrc
source ~/.bashrc
```

## 修改hosts文件

```shell
# echo IP地址 主机名 >> /etc/hosts
# 例如：
echo 192.168.1.243 alma >> /etc/hosts
```

## 安装docker

参考网址：https://docs.docker.com/engine/install/centos/

### 开始安装

```shell
yum install -y yum-utils

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

yum install docker-ce-20.10.6 docker-ce-cli-20.10.6 containerd.io docker-compose-plugin -y
```

### 启动服务

```shell
systemctl enable docker

systemctl start docker
```

### 给其他用户授权（可选）

```shell
groupadd docker

usermod -aG docker [UserName]
```
### 增加docker配置

```shell
cat <<EOF | tee /etc/docker/daemon.json
{
 "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

systemctl daemon-reload
systemctl restart docker
```

### 检查docker设置

查看信息，可以看到已经变为systemd了，例如：

```shell
docker info | grep Cgroup
```

查询结果类似：

```text
Cgroup Driver: systemd
Cgroup Version: 1
```

## 安装Kubernets

### 环境准备

关闭防火墙

```shell
systemctl stop firewalld.service
systemctl disable firewalld.service
```

禁用交换分区

```shell
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

禁用SELinux

```shell
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
```
### 安装

添加阿里源

```shell
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

添加源（可选，需科学上网）

```shell
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
```

安装

```shell
yum install -y kubelet-1.23.12 kubeadm-1.23.12 kubectl-1.23.12   # --disableexcludes=kubernetes

systemctl enable --now kubelet
```

### 镜像拉取

查看镜像版本

```shell
kubeadm config images list
```

创建文件pullk8simages.sh，就是把k8s.gcr.io库换成阿里云镜像地址，然后重新打标签k8s.gcr.io，最后删掉阿里的镜像

```shell
cat <<EOF | sudo tee pullk8simages.sh
#!/bin/bash

set -e

# 版本号根据上面查到的镜像版本填写
KUBE_VERSION=v1.23.12
KUBE_PAUSE_VERSION=3.6
ETCD_VERSION=3.5.1-0
CORE_DNS_VERSION=v1.8.6

GCR_URL=k8s.gcr.io
ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/google_containers

images=(kube-proxy:\${KUBE_VERSION}
kube-scheduler:\${KUBE_VERSION}
kube-controller-manager:\${KUBE_VERSION}
kube-apiserver:\${KUBE_VERSION}
pause:\${KUBE_PAUSE_VERSION}
etcd:\${ETCD_VERSION}
coredns:\${CORE_DNS_VERSION})

for imageName in \${images[@]} ; do
  docker pull \$ALIYUN_URL/\$imageName
  docker tag  \$ALIYUN_URL/\$imageName \$GCR_URL/\$imageName
  docker rmi \$ALIYUN_URL/\$imageName
done
EOF
```

执行命令：

```shell
sh pullk8simages.sh

docker tag k8s.gcr.io/coredns:v1.8.6 k8s.gcr.io/coredns/coredns:v1.8.6
```

### 初始化控制平面节点

```shell
kubeadm init --kubernetes-version v1.23.12 --pod-network-cidr=192.168.0.0/16
```

初始化后按照提示执行命令，例如：

```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

# 配置永久环境变量
cat > /etc/profile.d/kubeconfig.sh << EOF
export KUBECONFIG=/etc/kubernetes/admin.conf
EOF

source /etc/profile
```

### 节点配置

创建网络CNI，参考网址：https://projectcalico.docs.tigera.io/getting-started/kubernetes/quickstart

```shell
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# 查看状态，直到为Ready
kubectl get nodes

# 控制平面节点隔离
kubectl taint nodes --all node-role.kubernetes.io/master-
```

## Kuboard

### 安装

```shell
sudo docker run -d \
  --restart=unless-stopped \
  --name=kuboard \
  -p 8088:80/tcp \
  -p 10081:10081/tcp \
  -e KUBOARD_ENDPOINT="http://192.168.1.242:8088" \
  -e KUBOARD_AGENT_SERVER_TCP_PORT="10081" \
  -v /root/kuboard-data:/data \
  eipwork/kuboard:v3
```

默认用户和密码：

admin

Kuboard123

### 配置

#### 集群导入

添加集群选择：agent

导入成功后选择：使用ServiceAccount kuboard-admin，进入集群概要

#### 创建命名空间

创建后进入即可

### 部署mysql

#### 配置字典

名称空间 --> 空间名--> 配置中心 --> 配置字典 --> 创建ConfigMap

名称：mysql-env

添加条目：MYSQL_ROOT_PASSWORD，内容：momnext123456

#### 创建工作负载

名称空间 --> 空间名 --> 常用操作 --> 创建工作负载

基本信息：

|     项目     |        内容        |
| :----------: | :----------------: |
| 工作负载类型 | 部署（Deployment） |
| 工作负载分层 |       持久层       |
| 工作负载名称 |       mysql        |
|    副本数    |         1          |

容器信息 --> 添加工作容器：

|             项目              |                         内容                          |
| :---------------------------: | :---------------------------------------------------: |
|             名称              |                         mysql                         |
|        容器镜像: 镜像         |                     mysql:8.0.19                      |
|    容器镜像: 镜像拉取策略     |               始终拉取新镜像（Always）                |
|        命令/参数: 参数        | --default-authentication-plugin=mysql_native_password |
| 环境变量: 配置字典引用-->配置 |                       mysql-env                       |

存储挂载（目录和卷名可以根据实际情况自定义）：

|         项目          |        名称         |
| :-------------------: | :-----------------: |
|      数据卷名称       |      vol-data       |
|    HostPath: Path     | /momnext/mysql/data |
|    HostPath: Type     |   DircoryOrCreate   |
| HostPath --> 添加挂载 |   /var/lib/mysql    |

服务/应用路由

|   项目   |           名称            |
| :------: | :-----------------------: |
| 服务类型 |         NodePort          |
|   端口   | 3306  \|  30000  \|  3306 |

### 部署redis

#### 创建工作负载

名称空间 --> 空间名 --> 常用操作 --> 创建工作负载

基本信息：

|     项目     |        内容        |
| :----------: | :----------------: |
| 工作负载类型 | 部署（Deployment） |
| 工作负载分层 |       持久层       |
| 工作负载名称 |       redis        |
|    副本数    |         1          |

容器信息 --> 添加工作容器：

|          项目           |                       内容                       |
| :---------------------: | :----------------------------------------------: |
|          名称           |                      mysql                       |
|     容器镜像: 镜像      |                   mysql:8.0.19                   |
| 容器镜像: 镜像拉取策略  |             始终拉取新镜像（Always）             |
|     命令/参数: 参数     | '--appendonly yes' '--requirepass momnext123456' |
| 生命周期回调: PostStart |                      不设置                      |
| 生命周期回调: PostStop  |                      不设置                      |

存储挂载（目录和卷名可以根据实际情况自定义）：

|         项目          |        名称         |
| :-------------------: | :-----------------: |
|      数据卷名称       |      vol-data       |
|    HostPath: Path     | /momnext/redis/data |
|    HostPath: Type     |   DircoryOrCreate   |
| HostPath --> 添加挂载 |        /data        |

服务/应用路由

|   项目   |           名称            |
| :------: | :-----------------------: |
| 服务类型 |         NodePort          |
|   端口   | 6379  \|  30002  \|  6379 |

