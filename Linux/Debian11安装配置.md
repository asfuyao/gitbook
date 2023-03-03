# Debian 11 安装后

## 配置 vi

sudo apt install vim

.vimrc 配置文件参考如下：

```text
" 去掉 vi 的一致性
set nocompatible

" 显示行号
set number

" 开启语法高亮
syntax on

" 设置字体
"set guifont=Monaco:h13
" solarized 主题设置在终端下的设置
"let g:solarized_termcolors=256

" 设置不自动换行
set nowrap

" 设置以 unix 的格式保存文件（UNIX 系统下默认）
set fileformat=unix

" 自动缩进
set autoindent
set cindent

" Tab 键的宽度 = 4 个空格
set tabstop=4
" 统一缩进为 4
set softtabstop=4
set shiftwidth=4
" expandtab：缩进用空格来表示，noexpandtab：用制表符表示一个缩进
set expandtab

" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=5

" 光标移动到 buffer 的顶部和底部时保持 3 行距离
set scrolloff=3

" 启动显示状态行 (1), 总是显示状态行 (2)
set laststatus=2

" 使退格键（backspace）正常处理 indent, eol, start 等
set backspace=2
" 允许 backspace 和光标键跨越行边界
"set whichwrap+=<,>,h,l

" 可以在 buffer 的任何地方使用鼠标（类似 office 中在工作区双击鼠标定位）
set mouse=a
set selection=exclusive
set selectmode=mouse,key

" 搜索忽略大小写
set ignorecase
" 高亮显示匹配字符（回车后）
set hlsearch
" 搜索实时高亮显示所有匹配的字符
set incsearch

" 设置当文件被改动时自动载入
"set autoread

" 突出显示当前行
set cursorline

" 打开标尺，在屏幕右下角显示当前光标所处位置（设置了 statusline 可以忽略）
set ruler
" 状态行显示的内容
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ENC=%{&encoding}]\ [POS=%l,%v][%p%%]\ %{strftime(\"%Y.%m.%d\ -\ %H:%M\")}
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %l,%c%)\ %p%%

" 语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn

" 编码设置释义
" vim 内部使用的字符编码方式
"set encoding = 编码
"set enc = 编码
"set fileencoding = 编码
"set fenc = 编码
"fileencodings 是一个用逗号分隔的列表，简写 fencs

" 编码设置
"set enc=utf-8" 默认
"set fencs=utf-8,gb18030,gbk,gb2312,cp936,big5" 包含简体中文，繁体中文

```


## 开启 root SSH 登录的方法
Debian 默认禁用 root 用户 SSH 登录，安装时候创建特定用户作为管理员帐号，启用 root 用户步骤如下：
```shell
修改 root 密码
sudo passwd root

修改配置文件
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo vi /etc/ssh/sshd_config

找到下面相关配置：
# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# Expect .ssh/authorized_keys2 to be disregarded by default in future.
#AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2

修改如下
增加一句
PermitRootLogin yes

快速配置：
sudo sed -i "/^#PermitRootLogin/c"PermitRootLogin""yes"" /etc/ssh/sshd_config

补充
PermitRootLogin prohibit-password  #允许 root 登录，但禁止适用密码认证
可以配合使用 Pubkey 认证，修改 PubkeyAuthentication yes

重启服务生效
sudo systemctl restart ssh
```
## 格式化网卡命名
从 Debian 9 开始，（CentOS 7 开始，Ubuntu 16.04 开始），安装好后网卡名称变成了类似 ensxxx 这种随机名称（本例为 ens33，可能是其他数字）。

```shell
# 编辑 grub 配置文件
sudo vi /etc/default/grub

修改 GRUB_CMDLINE_LINUX=""为 GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"

# 直接使用 sed 编辑
sudo sed -i "/^GRUB_CMDLINE_LINUX=""/c GRUB_CMDLINE_LINUX=\"net.ifnames=0 biosdevname=0\"" /etc/default/grub

# 更新 grub 配置文件
sudo update-grub

# 然后下一节编辑配置文件并重启生效
vi /etc/network/interfaces
# 将 ensxxx 修改为 eth0

# 重启系统生效
reboot
网络配置
查看 IP 地址信息：

ip address 简写 ip a

或者使用 ifconfig

Debian 11 网络配置文件为：/etc/network/interfaces 。

默认配置使用 DHCP，安装过程并没有手动配置提示。内容如下：

$ cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug ens33  #ens33 修改为 eth0
iface ens33 inet dhcp  #ens33 修改为 eth0
修改 IP 地址：

sudo vi /etc/network/interfaces
# 修改为以下内容：
iface lo inet loopback
auto lo

auto eth0
iface eth0 inet static
address 10.10.1.5
netmask 255.255.255.0
#broadcast 10.10.1.255 #可选，上述配置了掩码
#network 10.10.1.0 #可选，上述配置了掩码
gateway 10.10.1.1
#dns-domain example.com
# domain 和 search 不能共存；如果同时存在，后面出现的将会被使用。
dns-search sysin.org
dns-nameservers 10.10.1.1 8.8.8.8 #注意 debian 11 默认没有安装 resolvconf，所以需要手动在 resolv.conf 中编辑 DNS
# 或者安装 resolvconf 后，在这里配置，将自动更新 resolv.conf
sudo apt install resolvconf
# iface eth0 inet6 auto #ipv6 自动配置，不写则表示禁用了

# DHCP 配置如下：
auto eth0
iface eth0 inet dhcp

# 配置 DNS
cat /etc/resolv.conf #如果已经安装 resolvconf，不要手动编辑，直接在上述 interfaces 中编辑 dns

# 重启网络
sudo systemctl restart networking
#sudo service networking restart
可以看到 Debian 网络配置方法并没有变更，Ubuntu 16.04 也是这样配置，但是 18.04 开始使用 netplan，20.04 同样使用 netplan 但是默认配置文件名称再次变更。

配置多个 IP：
auto eth0:0
iface eth0:0 inet static
    address 192.168.1.90
    netmask 255.255.255.0

auto eth0:1
iface eth0:1 inet static
    address 192.168.1.91
    netmask 255.255.255.0

添加静态路由（Linux 通用，临时，重启消失）：
route add -net 10.10.11.0/24 gw 10.10.1.1
Debian 配置永久静态路由：

#添加
cat >> /etc/network/interfaces << EOF
# static routes
up ip route add 10.10.12.0/24 via 10.10.1.1 dev eth0
up ip route add 10.10.13.0/24 via 10.10.1.1 dev eth0
up ip route add 10.10.14.0/24 via 10.10.1.1 dev eth0
up ip route add 10.10.15.0/24 via 10.10.1.1 dev eth0
up ip route add 10.10.16.0/24 via 10.10.1.1 dev eth0
EOF

#重启网络
systemctl restart networking

#验证
ip route
修改主机名
设置主机名：
hostnamectl set-hostname debian01 --static
或者：
sudo vi /etc/hostname
# 修改为主机名 debian01
debian01

添加 domain name：
sudo vi /etc/hosts
# 添加一行
127.0.0.1  debian01.sysin.org debian01
# 注意这里的格式，IP 后面先写 FQDN 再写主机名，与 CentOS 相同
# 先写 FQDN 后写主机名，顺序反了不影响解析，但是'hostname -f'命令无法显示 FQDN，只能显示主机名

查看 FQDN：
hostname -f

# 正确显示如下
debian01.sysin.org

```

## 设置时区

我们默认安装是已经正确设置时区，但是如果是第三方云主机时区就未必符合本地要求。

查看时区，有 CST 正确
date

设置
sudo timedatectl set-timezone Asia/Shanghai

或者使用向导选择
tzselect
修改镜像源
安装的时候已经可以选择 mirror，加速本地访问，可以访问 Debian worldwide mirror sites 查看选择可用的镜像站点。

# 模板使用 mirror.sjtu.edu.cn

# 备份
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 比如将默认官方中国像源 ftp.cn.debian.org 替换为 mirror.sjtu.edu.cn
sudo sed -i 's/ftp.cn.debian.org/mirror.sjtu.edu.cn/' /etc/apt/sources.list
## 中国可选镜像站点如下
ftp.cn.debian.org
mirrors.bfsu.edu.cn
mirrors.hit.edu.cn
mirror.sjtu.edu.cn
mirrors.tuna.tsinghua.edu.cn
mirrors.ustc.edu.cn
# 可以 ping 站点名称，对比一下延迟来选择
更新：

sudo apt update #更新源
sudo apt upgrade #更新已安装的包
sudo apt dist-upgrade #升级系统
sudo apt clean && sudo apt autoclean #清理下载文件的存档
# apt 是新版命令，替代 apt-get，apt-get 将来会淘汰
安装 SNMP
sudo apt install snmpd snmp

配置 NTP
这里使用 chrony 替代传统的 ntp，当然 ntp 也是可用的，两种默认都没有安装。

安装 chrony：
sudo apt install chrony

sudo systemctl enable chrony
sudo systemctl start chrony
sudo systemctl status chrony

# 查看配置文件，暂使用默认配置
cat /etc/chrony/chrony.conf

chrony 自带一个交互式工具 chronyc，在配置文件中指定了时间服务器之后，如果想查看同步状态，可以进入这个交互式工具的交互界面。
chronyc 有很多的子命令，可以输入 help 来查看
chronyc> help
    选项：
    sources [-v]    显示关于当前来源的信息
    sourcestats [-v]      显示时间同步状态（如时间偏移了多少之类）

查看：
chronyc sources -v
chronyc sourcestats -v

最基本配置：
$ cat /etc/chrony/chrony.conf
# Welcome to the chrony configuration file. See chrony.conf(5) for more
# information about usable directives.

# Include configuration files found in /etc/chrony/conf.d.
confdir /etc/chrony/conf.d

# Use Debian vendor zone.
pool 2.debian.pool.ntp.org iburst

修改 pool 2.debian.pool.ntp.org iburst 为指定的 NTP 服务器。
通常是修改为内网中的 NTP，保持时间的统一和可靠同步，否则一般不用修改。

例如 Ubuntu 中默认的是：
pool ntp.ubuntu.com        iburst maxsources 4
pool 0.ubuntu.pool.ntp.org iburst maxsources 1
pool 1.ubuntu.pool.ntp.org iburst maxsources 1
pool 2.ubuntu.pool.ntp.org iburst maxsources 2

这里的 pool 表示一组服务器，也可以用 sever 指令替代，标识一台服务器，可以是域名也可以是 IP 地址。
虚机安装 VMware Tools
默认自动安装，查看状态如下：
# 查看版本
vmtoolsd -v

# 查看运行状态
systemctl status vmtoolsd

如果未安装，执行如下命令安装：
apt install open-vm-tools
安装必备工具
根据需要安装自己常用的必备工具：

sudo apt install zip unzip
sudo apt install lrzsz
sudo apt install htop #已经收录
sudo apt install lnav
sudo apt install fd-find #fd 命令，已经收录，命令为 fdfind
sudo ln -s /usr/bin/fdfind /usr/local/bin/fd
sudo apt install ripgrep #rg 命令，已经收录
sudo apt install tree
sudo apt install build-essential #Following command will install essential commands like gcc, make etc.
#sudo apt install net-tools #ifconfig、netstat、route 等命令集，默认安装
sudo apt install ntp ntpdate ntpstat #可选，模板未安装
# nc lsof 系统自带
# pstree
sudo apt install psmisc
# ncdu：NCurses Disk Usage
sudo apt install ncdu
# dstat 监控 CPU、磁盘和网络使用率
sudo apt install dstat
Shell 配置
命令自动补全忽略大小写
echo 'set completion-ignore-case on' >> ~/.inputrc

修改 vmrc（vim 配置文件）
为当前用户创建 ~/.vimrc，内容参看上述 “配置 vi”

为将 .vimrc 添加到默认用户配置文件 cp ~/.vimrc /etc/skel/.vimrc

ll 常规版
一般 Linux 中默认定义了 ll 别名，但参数比较少，需要使用更加强大的 ll 别名。
Debian 默认并没有定义 ll 别名。
写入环境变量（当前用户优先执行）：
bash：
echo 'alias ll="ls -lahF --color=auto --time-style=long-iso"' >> ~/.bashrc

高级版 ls：以数字显示权限
这里我们把命令叫做 lll
命令：
ls -lahF --color=auto --time-style=long-iso | awk '{k=0;s=0;for(i=0;i<=8;i++){k+=((substr($1,i+2,1)~/[rwxst]/)*2^(8-i))}j=4;for(i=4;i<=10;i+=3){s+=((substr($1,i,1)~/[stST]/)*j);j/=2}if(k){printf("%0o%0o ",s,k)}print}'

创建文件
在使用 cat EOF 中出现 $ 变量通常会直接被执行，显示执行的结果。若想保持 $ 变量不变需要使用 \ 符进行注释。

# 如果非 root 用户，切换到 root
sudo -i
cat > /usr/local/bin/lll <<EOF
#!/bin/bash
ls -lahF --color=auto --time-style=long-iso | awk '{k=0;s=0;for(i=0;i<=8;i++){k+=((substr(\$1,i+2,1)~/[rwxst]/)*2^(8-i))}j=4;for(i=4;i<=10;i+=3){s+=((substr(\$1,i,1)~/[stST]/)*j);j/=2}if(k){printf("%0o%0o ",s,k)}print}'
EOF

# 赋予执行权限：
chmod +x /usr/local/bin/lll

# 如果非 root 用户，执行完毕退出
exit

写入环境变量（可选配置，默认不需要）：
bash
echo 'alias lll="/usr/local/bin/lll"' >> ~/.bashrc
关于防火墙或者包过滤
Debian 11 默认使用 nftables 作为 netfilter 前端，使用 nft 命令进行管理，但是默认并没有启用。

Linux 内核嵌入了 netfilter 防火墙，可以从用户空间使用 iptables、ip6tables、arptables 和 ebtables 命令对其进行控制。 然而，Netfilter iptables 命令正在被 nftables 取代，这避免了它的许多问题。 它的设计涉及较少的代码重复，并且只需使用 nft 命令即可对其进行管理。

Debian Buster（即 Debian 10，包括 11）默认使用 nftables 框架。

要在 Debian 中启用默认防火墙，请执行：
apt install -y nftables
systemctl enable nftables.service
关于 nft 命令的语法和用例，参看其他文章。

清理
清理 apt 缓存
sudo apt clean && sudo apt autoclean #清理下载文件的存档

清理临时文件夹
rm -rf /tmp/*  # 清空临时文件夹

清空历史记录
#比较完整的清空历史记录
#debian/ubuntu use auth.log
rm -f /var/log/auth.log.*
echo > /var/log/auth.log
#rm -f /var/log/audit/audit*
#echo > /var/log/audit/audit.log
rm -f /var/log/secure*
echo > /var/log/secure
rm -f /var/log/btmp*
echo > /var/log/btmp
echo > /var/log/lastlog
rm -f /var/log/wtmp*
echo > /var/log/wtmp
#以上需要 root，以下当前用户执行
echo > ~/.bash_history
echo > ~/.zsh_history
history -c