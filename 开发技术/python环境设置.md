# 使用国内源

* Linux下，创建 ~/.pip/pip.conf

* Windows下，创建%HOMEPATH%\pip\pip.ini

选择性写入下面内容：

阿里源

```ini
[global]
index-url=http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
```

清华源

```ini
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple

[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
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

# VSCode下使用虚拟环境调试

* 按F1，选择Python解释器，Python: Select Interpreter
* 选择：.\venv\Scripts\python.exe
