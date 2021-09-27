<!-- TOC -->

- [1. 安装插件](#1-安装插件)
- [2. 修改vue.config.js](#2-修改vueconfigjs)
- [3. 创建运行和调试配置文件](#3-创建运行和调试配置文件)
- [4. 一个完整的vue.config.js例子](#4-一个完整的vueconfigjs例子)

<!-- /TOC -->

# 1. 安装插件

安装vscode插件：Debugger for Microsoft Edge

# 2. 修改vue.config.js

添加下面配置

```json
configureWebpack: {
  devtool: 'source-map'
}
```

# 3. 创建运行和调试配置文件

新建Edge launch，并修改成下面格式

```json
{
    // 使用 IntelliSense 了解相关属性。 
    // 悬停以查看现有属性的描述。
    // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "type": "pwa-msedge",
            "request": "launch",
            "name": "Launch Edge against localhost",
            "url": "http://localhost:8080",  //地址
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
