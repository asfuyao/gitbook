# 使用国内源

* Linux下，创建 ~/.pip/pip.conf

* Windows下，创建%HOMEPATH%\pip\pip.conf

写入下面内容：

```ini
[global]
index-url=http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
```

# 安装并设置virtualenv虚拟环境

```shell
# 安装virtualenv
pip inistall virtualenv

# 进入项目目录，创建虚拟环境目录
virtualenv venv

# windows下激活虚拟环境
venv\scripts\activate
```

