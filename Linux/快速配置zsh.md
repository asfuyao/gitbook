---
layout:     post
title:      快速配置zsh
subtitle:   zsh的快速配置
date:       2017-06-19
author:     BY
header-img: img/post-bg-universe.jpg
catalog: true
tags:
    - 终端
    - zsh
    - Notaan
---

# 安装zsh

```shell
# 安装 Zsh
sudo apt install zsh

# 将 Zsh 设置为默认 Shell
chsh -s /bin/zsh

# 可以通过 echo $SHELL 查看当前默认的 Shell，如果没有改为 /bin/zsh，那么需要重启 Shell。
```

# 安装 oh my zsh

	# 安装 Oh My Zsh
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	# 以上命令可能不好使，可使用如下两条命令
	sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# zsh配置

## 安装插件

```shell
# 快速访问文件或目录
sudo apt install fasd
# 用法
alias f='fasd -f'          # 文件
alias d='fasd -d'        # 目录
alias a='fasd -a'        # 任意
alias s='fasd -si'       # 显示并选择
alias sd='fasd -sid'        # 选择目录
alias sf='fasd -sif'          # 选择文件
alias z='fasd_cd -d'       # 跳转至目录
alias zz='fasd_cd -d -i'  # 选择并跳转至目录

# 命令行命令键入时的历史命令建议插件
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 命令行语法高亮插件
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 
```

## 安装字体

推荐在终端使用 Powerline 类型的主题，该类型主题可以使用图形表示尽可能多的信息，方便用户的使用。安装用户量最大的 [Powerlevel9k](https://github.com/bhilburn/powerlevel9k)，Powerlevel9k 中需要使用较多的图形符号，字体大多不会自带这些符号，所以需要使用专门的 Powerline 字体。推荐字体[Hack](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack/Regular/complete)

推荐安装Powerlevel9k的升级版Powerlevel10k，新版本速度大大提升，官网：https://github.com/romkatv/powerlevel10k

**安装好系统后，需要给终端配置字体**

## PowerLeveL10K 主题安装

```shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### .zshrc配置文件修改

```shell
# 设置主题
ZSH_THEME="powerlevel10k/powerlevel10k"
```

### 设置向导

```shell
p10k configure
```

## Powerlevel9k 主题安装

### 安装主题

```shell
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
```

### .zshrc配置文件修改

```shell
# 设置插件
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
# 设置别名
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias vi="vim"
```