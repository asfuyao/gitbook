# 用于 ISO 构建的 Docker

官方手册中也描述了不使用Docker的Native Build的方法，但是手册中也描述了由于依赖等原因Docker是一种简单的方法，所以这次将是使用Docker的创建过程......

## 从 DocukerHub 下载容器。

```shell
docker pull vyos/vyos-build:equuleus
```

## ISO 创建

下面的命令指定版本 1.3.0。如果有想要的版本，更改版本的描述并执行。* 但是只能指定 1.3 版本，因为 1.2 和 1.4 有不同的分支。（参见此处了解1.2 版本）

```shell
git clone -b equuleus --single-branch https://github.com/vyos/vyos-build
cd vyos-build/
docker run --rm -it --privileged -v $(pwd):/vyos -w /vyos --sysctl net.ipv6.conf.lo.disable_ipv6=0  -e GOSU_UID=$(id -u) -e GOSU_GID=$(id -g) vyos/vyos-build:equuleus bash
./configure --architecture amd64 --build-type release --version 1.3.0
sudo make iso
```

## 查看iso

执行完成后，将在 build 目录中创建以下 ISO 映像。由于它是在 Docker 运行时通过 -v 选项挂载到主机端的，因此在 Docker 主机端也可以确认相同的文件。

```shell
ls -l build/*iso
```
