# WSL2之Docker数据迁移

安装docker后，docker会自动创建2个发行版：

- docker-desktop
- docker-desktop-data

WSL发行版默认都是安装在C盘，在%LOCALAPPDATA%/Docker/wsl目录
Docker的运行数据、镜像文件都存在%LOCALAPPDATA%/Docker/wsl/data/ext4.vhdx中

## 数据迁移方法

```powershell
#1. 首先关闭Docker
#2. 关闭所有发行版
wsl --shutdown
#3. 导出docker-desktop-data和docker-desktop
wsl --export docker-desktop-data D:\docker\docker-desktop-data.tar
wsl --export docker-desktop D:\docker\docker-desktop.tar
#4. 注销docker-desktop-data和docker-desktop
wsl --unregister docker-desktop-data
wsl --unregister docker-desktop
#5. 导入docker-desktop-data和docker-desktop
wsl --import docker-desktop-data D:\docker\wsl D:\docker\docker-desktop-data.tar --version 2
wsl --import docker-desktop D:\docker\wsl D:\docker\docker-desktop.tar --version 2
#6. 启动Docker
#7. 完成后可删除导出的两个tar文件
```

