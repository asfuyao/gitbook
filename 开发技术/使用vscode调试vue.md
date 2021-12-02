<!-- TOC -->

- [1. 安装插件](#1-安装插件)
- [2. 修改vue.config.js](#2-修改vueconfigjs)
- [3. 创建运行和调试配置文件](#3-创建运行和调试配置文件)
- [4. 一个完整的vue.config.js例子](#4-一个完整的vueconfigjs例子)

<!-- /TOC -->

# 1. 安装插件

安装vscode插件

* Edge浏览器: Debugger for Microsoft Edge
* Chrome浏览器: Debugger for Chrome


# 2. 修改vue.config.js

添加下面配置，configureWebpack内有其他设置可能会有影响，目前不知道如何和其他配置共存

```json
configureWebpack: {
  devtool: 'source-map'
}
```

# 3. 创建运行和调试配置文件

在debug试图，创建.vscode/launch.json（可自动创建或手工创建）,改成下面内容

Edge浏览器：

```json
{
    // 使用 IntelliSense 了解相关属性。 
    // 悬停以查看现有属性的描述。
    // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "type": "pwa-msedge", //chrome浏览器改为：pwa-chrome
            "request": "launch",
            "name": "vuejs: msedge",
            "url": "http://localhost:8080",  //根据实际地址和端口填写
            "webRoot": "${workspaceFolder}/src",
            "breakOnLoad": true,
            "sourceMapPathOverrides": {
                "webpack:///src/*": "${webRoot}/*"
            }
        }
    ]
}
```

# 4. 一个完整的vue.config.js例子

```vue
module.exports = {
  publicPath: './',
  assetsDir: 'static',
  productionSourceMap: false,
  devServer: {
    proxy: {
      '/api/Base': {
        target: 'http://localhost:8100', //后台服务地址
        changeOrigin: false,
        pathRewrite: {
          '^/api/Base': '/'
        }
      },
      '/api/Mes': {
        target: 'http://localhost:8002', //后台服务地址
        changeOrigin: false,
        pathRewrite: {
          '^/api/Mes': '/'
        }
      },
      '/api/Wms': {
        target: 'http://localhost:8003', //后台服务地址
        changeOrigin: false,
        pathRewrite: {
          '^/api/Wms': '/'
        }
      }

    }
  },
  configureWebpack: {
    devtool: 'source-map'
  }
};
```

# 5. 运行和debug

* 在vscode的终端窗口执行：yarn run serve 或 npm run serve
* 到debug视图点绿色三角号运行之前的配置
* 这是编辑窗口上方的debug条会出现下拉框，选择vuejs: msedge即可