# 设置代理

## 方法一

```shell
go env -w GOPROXY=https://goproxy.io,direct
```

## 方法二

* 右键 我的电脑 -> 属性 -> 高级系统设置 -> 环境变量
* 在 “[你的用户名]的用户变量” 中点击 ”新建“ 按钮
* 在 “变量名” 输入框并新增 “GOPROXY”
* 在对应的 “变量值” 输入框中新增 “https://proxy.golang.com.cn,direct”
* 最后点击 “确定” 按钮保存设置
