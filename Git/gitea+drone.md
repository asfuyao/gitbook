# gitea整合drone

* 本文中gitea和drone不在一台服务器（在同一台服务器部署没成功原因未知）
* 示例中gitea服务器地址：giteaserver:3000，drone服务器地址：droneserver:8000，实际使用中可用ip地址或域名替代


## gitea

### docker-compose部署

```yml
networks:
  gitea:
    external: false

services:
  gitea:
    image: docker.gitea.com/gitea:1.23.7
    container_name: gitea
    environment:
      - USER_UID=1000
      - USER_GID=1000
    restart: always
    networks:
      - gitea
    volumes:
      - ./data:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "3000:3000"
      - "2222:22"
```

### 初始化配置

* 访问http://giteaserver:3000，会出现初始化配置页面，根据需要进行配置
* 登录后创建一个代码仓库作为测试，

### 创建OAuth2应用

* 点击右上角用户图标，下拉菜单中选择：管理后台
* 左侧菜单：集成 -> 应用
* 填写应用内容，应用名：drone，重定向URI：http://droneserver:8000/login
* 点击创建应用，记录：客户端ID、客户端密钥
* 点击保存，完成应用创建

### 添加webhook白名单

编辑文件：data/gitea/conf/app.ini添加如下内容

```ini
[webhook]
ALLOWED_HOST_LIST = droneserver
```

### 添加流水线文件

在代码库中添加测试的流水线文件：.drone.yml，文件内容如下：

```yaml
kind: pipeline # 定义一个管道
type: docker # 当前管道的类型
name: test # 当前管道的名称
steps: # 定义管道的执行步骤
  - name: test # 步骤名称
    image: erpdev.top:20085/microservice/vuewebdemo:v1.0 # 当前步骤使用的镜像
    commands: # 当前步骤执行的命令
      - echo 测试drone执行
```

## grone

### 部署grone服务

首先执行：`openssl rand -hex 16`生成共享密钥，Runner连接drone服务时使用

```shell
docker run \
  --volume=/存放drone数据的目录:/data \
  --env=DRONE_GITEA_SERVER=http://giteaserver:3000 \
  --env=DRONE_GITEA_CLIENT_ID=客户端ID \
  --env=DRONE_GITEA_CLIENT_SECRET=客户端密钥 \
  --env=DRONE_RPC_SECRET=共享密钥 \
  --env=DRONE_SERVER_HOST=droneserver:8000 \
  --env=DRONE_SERVER_PROTO=http \
  --publish=8000:80 \
  --publish=8443:443 \
  --restart=always \
  --detach=true \
  --name=drone \
  drone/drone:2
```

### 初始化grone

* 浏览器访问：http://droneserver:8000
* 自动进入gitea的授权页面，点击：应用授权
* 返回drone，填写初始用户名和密码
* 进入后点击右上角sync，同步代码库
* 点击要激活的仓库名进入并激活
* 在Settings中进行设置，记住默认的Configuration文件名之后要用到(默认为.drone.yml)，点击SAVE CHANGES保存设置

### 部署grone Runner

执行命令：`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' drone`查看drone容器IP

```shell
docker run --detach \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  --env=DRONE_RPC_PROTO=http \
  --env=DRONE_RPC_HOST=drone容器IP地址 \
  --env=DRONE_RPC_SECRET=共享密钥 \
  --env=DRONE_RUNNER_CAPACITY=2 \
  --env=DRONE_RUNNER_NAME=runner-docker \
  --publish=3000:3000 \
  --restart=always \
  --name=drone-runner \
  drone/drone-runner-docker:1
```

执行命令：`docker logs drone-runner`查看是否有报错

## 流水线测试

* 进入包含.drone.yml文件的代码库
* 点击设置进入代码库设置页
* 点击左侧菜单：Web钩子，此时应该看到一条grone创建的Web钩子，点击地址进入
* 在最下面可以进行测试推送
* 点击测试推送后返回grone，进入对应的Repositories中
* 此时应该看到测试执行的记录点击记录可以看到明细