# 实验环境

* 三台CentOS8虚拟机
* 设置固定IP
* 修改源为阿里云
* 禁用IPv6

```shell
#编辑配置文件
sudo vi /etc/default/grub
#在末尾添加：GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX ipv6.disable=1"
#保存并退出配置文件,下一步是更新GRUB CFG文件，键入以下命令以找到grub文件
sudo ls -lh /etc/grub*.cfg
#如看到2个GRUB CFG文件路径：/boot/grub2/grub.cfg和/boot/efi/EFI/centos/grub.cfg则都需要更新
#键入以下命令以创建新的GRUB配置文件并将其保存到/boot/grub2/grub.cfg
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
#最后，重新启动您的CentOS 8计算机。
sudo reboot
```



# 前期准备

## 修改hostname

```shell
sudo vi /etc/hostname
```

## 修改hosts

```shell
sudo vi /etc/hosts
```

将三台主机的ip和名称进行映射

```shell
192.168.91.51 master
192.168.91.52 worker1
192.168.91.53 worker2
```

## 安装docker

```shell
#安装必要的一些系统工具
sudo yum install -y yum-utils
#添加docker源
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
#安装docker
sudo yum install docker-ce docker-ce-cli containerd.io
#启动docker
sudo systemctl enable docker.service
sudo systemctl start docker
#给fuyao用户授权
sudo usermod -aG docker fuyao
```

# 安装k8s(切换至root用户)

## 添加k8s阿里云源

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

## 修改docker配置文件添加阿里云镜像

```shell
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
     "https://gyjor9dg.mirror.aliyuncs.com",
     "https://docker.mirrors.ustc.edu.cn",
     "http://f1361db2.m.daocloud.io",
     "https://registry.docker-cn.com"
  ],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
systemctl daemon-reload
systemctl restart docker
```

## 安装k8s

```shell
swapoff -a
#关闭selinux防火墙，但重启后失效
setenforce 0
#停止网络防火墙
systemctl disable firewalld
systemctl stop firewalld
#安装和启动
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet
#查看版本
kubectl version
```

## 修改网络配置

```shell
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```

# 初始化Master

```shell
kubeadm config print init-defaults > kubeadm-init.yaml
```

该文件有两处需要修改:

* 将 advertiseAddress: 1.2.3.4 修改为本机地址
* 将 imageRepository: k8s.gcr.io 修改为 registry.cn-hangzhou.aliyuncs.com/google_containers

修改完毕后文件如下:

```yml
apiVersion: kubeadm.k8s.io/v1beta2
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 1.2.3.4
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  name: master
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta2
"kubeadm-init.yaml" 38L, 826C
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns:
  type: CoreDNS
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: k8s.gcr.io
kind: ClusterConfiguration
kubernetesVersion: v1.19.0
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}
```

## 下载镜像

```shell
kubeadm config images pull --config kubeadm-init.yaml
```

## 禁用Swap

```shell
swapoff -a
```

## 执行初始化

```shell
kubeadm init --config kubeadm-init.yaml
```

初始化后生成类似信息表示成功：

```shell
kubeadm join 192.168.91.51:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:2eef17b9c89d250af41af747890f9a4d09eba6c63614970f5e65292ad46e3d46
```

## 配置环境, 让当前用户可以执行kubectl命令

```shell
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
#执行kubectl命令
kubectl get node
#此时显示应是这个样的：
NAME     STATUS     ROLES    AGE    VERSION
master   NotReady   master   3m4s   v1.19.4
```

## 配置网络

```shell
#安装Calico
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f calico.yaml
#再次查看node信息，状态已经是Ready了
NAME     STATUS   ROLES    AGE     VERSION
master   Ready    master   6m34s   v1.19.4
```

## 安装Dashboard

### 部署Dashboard

文档地址: [Deploying the Dashboard UI](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#deploying-the-dashboard-ui)

```shell
wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
## 异常无法连接
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 0.0.0.0, ::
Connecting to raw.githubusercontent.com
(raw.githubusercontent.com)|0.0.0.0|:443... failed: Connection refused.
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|::|:443...
failed: Connection refused.
## 解决
## 解决GitHub的raw.githubusercontent.com无法连接问题
## 1、https://site.ip138.com/raw.Githubusercontent.com/
## 2、输入raw.githubusercontent.com，查询IP地址，获取到对应的IP：151.101.108.133
## 3、编辑/etc/hosts文件配置映射151.101.108.133 raw.githubusercontent.com

kubectl apply -f recommended.yaml

#部署完毕后，查看pods状态
kubectl get pods --all-namespaces | grep dashboard
#应该显示：
kubernetes-dashboard   dashboard-metrics-scraper-7b59f7d4df-c9jm6   1/1     Running   0          82s
kubernetes-dashboard   kubernetes-dashboard-74d688b6bc-g9klx        1/1     Running   0          82s
```

### 访问Dashboard

这里作为演示，使用nodeport方式将dashboard服务暴露在集群外，指定使用30443端口，可自定义：

```shell
kubectl -n kubernetes-dashboard get svc
#显示下面内容
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
dashboard-metrics-scraper   ClusterIP   10.101.150.55   <none>        8000/TCP   3m34s
kubernetes-dashboard        ClusterIP   10.110.90.51    <none>        443/TCP    3m34s

#修改端口
kubectl patch svc kubernetes-dashboard -n kubernetes-dashboard \
 -p '{"spec":{"type":"NodePort","ports": [{"port":443,"targetPort":8443,"nodePort":30443}]}}'
```

查看暴露的service,已修改为nodeport类型：

```shell
kubectl -n kubernetes-dashboard get svc
#执行后显示
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
dashboard-metrics-scraper   ClusterIP   10.101.150.55   <none>        8000/TCP        4m42s
kubernetes-dashboard        NodePort    10.110.90.51    <none>        443:30443/TCP   4m42s
```

### 修改配置文件后安装

也可以在安装Dashboard前修改yaml文件配置端口

```shell
vim ~/recommended.yaml
```

```yaml
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  type: NodePort
  ports:
    - port: 443
    targetPort: 8443
    nodePort: 30443
  selector:
    k8s-app: kubernetes-dashboard
```

## 创建用户

### 创建文件

创建一个用于登录Dashboard的用户. 创建文件 dashboard-adminuser.yaml 内容如下:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
```

执行命令：

```shell
kubectl apply -f dashboard-adminuser.yaml
```

### 生成证书

```shell
grep 'client-certificate-data' ~/.kube/config | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.crt
grep 'client-key-data' ~/.kube/config | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.key
openssl pkcs12 -export -clcerts -inkey kubecfg.key -in kubecfg.crt -out kubecfg.p12 -name "kubernetes-client"
```

第三条命令生成证书时会提示输入密码, 可以直接两次回车跳过.
kubecfg.p12 即需要导入客户端机器的证书. 将证书拷贝到客户端机器上, 导入即可

```shell
scp root@192.168.3.222:/root/.kube/kubecfg.p12 ./
```

需要注意的是: 若生成证书时跳过了密码, 导入时提示填写密码直接回车即可, 不要纠结密码哪来的

此时我们可以登录面板了, 访问地址: https://192.168.3.222:30443 , 登录时会提示选择证书, 确认后
会提示输入当前用户名密码(注意是电脑的用户名密码).

### 登录Dashboard

获取Token

```shell
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
```



# 添加Worker节点

执行如下命令（之前master节点初始化后生成的）：

```shell
swapoff -a

kubeadm join 192.168.91.51:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:2eef17b9c89d250af41af747890f9a4d09eba6c63614970f5e65292ad46e3d46 --ignore-preflight-errors=Swap
```

添加完毕后, 在Master上查看节点状态:

```shell
kubectl get node
#查看结果

```



