---
layout: post
title:  Git仓库迁移，包括所有的分支、标签、日志
subtitle:   Linux相关
date:   2020-05-11
author: Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:
- Linux
- Github
- Git
---

# 导出仓库

```cmd
git clone --bare http://域名/分组/仓库名称.git
```

# 进入仓库

```cmd
cd 仓库名称.git
```

# 恢复仓库

```cmd
git push --mirror http://新域名/新分组/新仓库名称.git