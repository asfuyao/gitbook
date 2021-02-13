# 安装Command Line Tools for Xcode

Command Line Tools 就是一个小型独立包，为mac终端用户提供了许多常用的工具，实用程序和编译器。包括svn，git，make，GCC，clang，perl，size，strip，strings，libtool，cpp，what以及其他很多能够在Linux默认安装中找到的有用的命令，下载地址：https://developer.apple.com/download/more/

# 安装 Homebrew

访问官网：https://brew.sh 获取最新安装命令（需要科学上网）

# 安装 Nvm
Nvm 是一个管理 Node 版本的工具，当项目多了以后，总会碰到需要切换 Node 环境的时候，所以推荐大家使用 Nvm 来安装 Node。

brew install nvm

# 设置 Nvm 的环境变量
安装好 nvm 后，按提示设置环境变量

例如：zsh下将下面语句加入.zshrc

```shell
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
```

至此 Nvm 已经安装好，可以尝试在命令行中输入 nvm，你可以看到 nvm 已经正常工作了。

# 安装 Node

## 安装适配M1的node版本

安装最新lts版本：

```shell
nvm install --lts
```

该命令运行完后，会执行很久，编译 node ，大家耐心等就好了，大概需要 5-10 分钟，就会提示安装成功。再提醒一句，报任何错误，首先先检查是不是网络问题，例如 443 、 connect timeout 等，如果是网络问题，建议科学上网。

## 安装v14及以下的老版本Node
安装 Node 的部分写的很简单，因为按这个步骤，一般不会出问题。而当你用 nvm 尝试去安装 v14 及以下的 Node 版本时，大概率会报错，而我们在工作中恰恰又可能依赖 v14 及以下的 lts 版本。那么为什么会报错呢？究其原因还是因为低版本的 node 并不是基于 arm64 架构的，所以不适配 M1 芯片。在这里教大家两个方法，就能成功安装上低版本 Node。

### 方法一

在终端中，输入：

```shell
arch -x86_64 zsh
```

通过这个命令可以让 shell 运行在Rosetta2下。
之后你可以通过 nvm install v12 来安装低版本 Node。
在此之后，您可以不用在 Rosetta2 中就可以使用安装的可执行文件，也就是说，您可以将 Node v15与其他节点版本互换使用。

### 方法二
方法二就是通过 Rosetta2 来启动终端，这样通过 Rosetta2 转译到 x86 架构中执行安装，也一样可以安装成功。

在 finder 中，点击应用程序，并在实用工具中找到终端 (Terminal)
右键终端，点击获取信息
选择 使用Rosetta 打开
重启终端，并执行 nvm install v12 命令
