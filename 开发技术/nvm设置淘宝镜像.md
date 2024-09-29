# nvm设置淘宝镜像

## 设置nvm镜像

设置node

```shell
# Windows
nvm node_mirror https://npmmirror.com/mirrors/node/
nvm npm_mirror https://npmmirror.com/mirrors/npm/

# linux
export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node
export NVM_IOJS_ORG_MIRROR=https://npmmirror.com/mirrors/iojs
```

## nvm use

Windows下需用管理员权限运行nvm use

## 设置npm镜像

淘宝镜像
```shell
npm config set registry https://registry.npmmirror.com
```

官方镜像
```shell
npm config set registry https://registry.npmjs.org/
```

## 设置yarn镜像

如果无法运行yarn，需自行下面命令

```shell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

淘宝镜像
```shell
yarn config set registry https://registry.npmmirror.com
```

官方镜像
```shell
yarn config set registry https://registry.yarnpkg.com
```