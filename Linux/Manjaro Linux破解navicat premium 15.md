# 破解过程

## 展开软件包

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

方法三（推荐）：

```shell
yay -S navicat15-premium-cs
# 安装后路径为：/opt/navicat15-premium-cs
```

## 编译Keygen

```shell
yay -S capstone rapidjson openssl keystone
git clone -b linux --single-branch https://github.com/lzscxb/navicat-keygen.git
cd navicat-keygen-linux
make all
```

## 破解

```shell
cd navicat
./navicat-keygen/bin/navicat-patcher ./

#方法三
cd /opt/navicat15-premium-cs
路径/navicat-keygen/bin/navicat-patcher ./
```

## 重新打包

```shell
yay -S appimagetool
appimagetool navicat navicat15-premium-cs-15.0.30-patched.AppImage
```

## 注册

```shell
./navicat15-premium-cs-15.0.30-patched.AppImage &
cd navicat-keygen
cp ../navicat/RegPrivateKey.pem ./
bin/navicat-keygen --text ./RegPrivateKey.pem
# 类型选择 1 premium
# 语言选择 1 simplified chinese
# 版本选择 15
# 在软件中填入生成的序列号，最好断网后进行，序列号如果不行就重新生成一个
# 用户名和公司名随便添
# 粘贴request code后两次回车
# 粘贴激活码到软件
```
