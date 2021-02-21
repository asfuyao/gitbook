# 使用国内源

* Linux下，创建 ~/.pip/pip.conf

* Windows下，创建%HOMEPATH%\pip\pip.ini

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
pip install virtualenv

# 进入项目目录，创建虚拟环境目录
virtualenv venv

# windows下激活虚拟环境
venv\scripts\activate
```

# 安装项目依赖

pip install -r requirements.txt

requirements.txt内容举例：

```text
Flask==1.1.2
Flask-Cors==3.0.8
requests==2.22.0
Werkzeug==0.15.5
```

