# 终端下设置代理上网

```shell
# 设置代理（本机）
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890
# 设置代理（其他主机）
export https_proxy=http://192.168.91.100:7890 http_proxy=http://192.168.91.100:7890
# 取消代理设置
unset https_proxy http_proxy

# git设置代理
git config --global http.proxy 'http://192.168.91.100:7890'
git config --global https.proxy 'http://192.168.91.100:7890'

# git取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

# 添加快速设置代理命令

编辑 .bashrc 或 .zshrc 添加下面脚本

```shell
alias proxyoff='unset https_proxy http_proxy'
alias proxyon='export https_proxy=http://192.168.91.100:7890 http_proxy=http://192.168.91.100:7890'
```

