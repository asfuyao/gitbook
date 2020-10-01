# 安装Debian10

仅安装ssh server和基本工具

# 添加OMV源

```shell
cat <<EOF >> /etc/apt/sources.list.d/openmediavault.list
deb https://packages.openmediavault.org/public usul main
# deb https://downloads.sourceforge.net/project/openmediavault/packages usul main
## Uncomment the following line to add software from the proposed repository.
# deb https://packages.openmediavault.org/public usul-proposed main
# deb https://downloads.sourceforge.net/project/openmediavault/packages usul-proposed main
## This software is not part of OpenMediaVault, but is offered by third-party
## developers as a service to OpenMediaVault users.
# deb https://packages.openmediavault.org/public usul partner
# deb https://downloads.sourceforge.net/project/openmediavault/packages usul partner
EOF
```

```shell
cat <<EOF >> /etc/apt/sources.list.d/openmediavault.list
deb https://mirrors.bfsu.edu.cn/OpenMediaVault/public/ usul main
deb https://mirrors.bfsu.edu.cn/OpenMediaVault/public/ usul-proposed main
deb https://mirrors.bfsu.edu.cn/OpenMediaVault/public/ usul partner
EOF

cat <<EOF >> /etc/apt/sources.list.d/openmediavault.list
deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public/ usul main
deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public/ usul-proposed main
deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public/ usul partner
EOF
```


# 执行安装命令

```shell
export LANG=C.UTF-8
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
wget -O "/etc/apt/trusted.gpg.d/openmediavault-archive-keyring.asc" https://packages.openmediavault.org/public/archive.key
apt-key add "/etc/apt/trusted.gpg.d/openmediavault-archive-keyring.asc"
apt-get update
apt-get --yes --auto-remove --show-upgraded \
    --allow-downgrades --allow-change-held-packages \
    --no-install-recommends \
    --option Dpkg::Options::="--force-confdef" \
    --option DPkg::Options::="--force-confold" \
    install openmediavault-keyring openmediavault


# Populate the database.
omv-confdbadm populate


# Display the login information.
cat /etc/issue
```

# 安装扩展插件

```shell
wget -O - https://github.com/OpenMediaVault-Plugin-Developers/packages/raw/master/install | bash
```
