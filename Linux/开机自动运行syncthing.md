# 创建脚本

```shell
sudo vi /etc/systemd/system/syncthing.service
```

输入以下内容：

```shell
[Unit]
Description=syncthing
After=network.target

[Service]
Type=simple
User=fuyao
ExecStart=/usr/bin/syncthing
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

设置开机自动运行，并启动服务

```shell
sudo systemctl enable syncthing.service
sudo systemctl start syncthing.service
```
