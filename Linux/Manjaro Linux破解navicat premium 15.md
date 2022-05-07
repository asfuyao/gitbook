# 1. 准备工作

## 1.1. 编译Keygen

```shell
yay -S capstone rapidjson openssl keystone
git clone -b linux --single-branch https://github.com/lzscxb/navicat-keygen.git
cd navicat-keygen
make all
```

## 1.2. 修改host文件

修改hosts文件添加下面行
```text
# For Navicat Premium
127.0.0.1 activate.bitsum.com
127.0.0.1 activate.navicat.com
```

# 2. 安装文件破解

## 2.1. 展开软件包

方法一：好像只适合英文版

```shell
chmod a+x navicat15-premium-cs-15.0.30.AppImage
./navicat15-premium-cs-15.0.30.AppImage --
```

方法二：

```shell
mkdir navicat15-premium-cs
sudo mount -o loop navicat15-premium-cs-15.0.30.AppImage navicat15-premium-cs
cp -vr navicat15-premium-cs navicat
sudo umount navicat15-premium-cs
rm -rf navicat15-premium-cs
```

## 2.2. 破解

```shell
cd navicat
路径/navicat-keygen/bin/navicat-patcher ./
#破解后会生成RegPrivateKey.pem文件，注册时用
```

## 2.3. 重新打包

```shell
yay -S appimagetool
appimagetool navicat navicat15-premium-cs-15.0.30-patched.AppImage
```

# 3. 安装后破解

```shell
yay -S navicat15-premium-cs
# 安装后路径为：/opt/navicat15-premium-cs
```

## 3.1. 破解

```shell
cd /opt/navicat15-premium-cs
路径/navicat-keygen/bin/navicat-patcher ./
#破解后会生成RegPrivateKey.pem文件，注册时用
```

# 4. 注册激活

运行安装或重新打包的软件，按下面步骤注册激活：

```shell
cd navicat-keygen
路径/navicat-keygen/bin/navicat-keygen --text ./RegPrivateKey.pem
# 类型选择 1 premium
# 语言选择 1 simplified chinese
# 版本选择 15
# 在软件中填入生成的序列号，序列号如果不行就重新生成一个
# 用户名和公司名随便添
# 粘贴request code后两次回车
# 粘贴激活码到软件
```
