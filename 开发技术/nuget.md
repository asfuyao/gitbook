# 常用操作

## 添加程序包源

* 进入程序包源设置：VS菜单 -> 工具 -> 选项 -> NuGet包管理器 -> 程序包源
* 添加新的源：点击 + 号，名称：banuget，源：http://192.168.1.7:8500/v3/index.json，点击 更新 按钮完成添加
* 如果在命令行可以执行下面命令，效果同上

```shell
nuget sources add -AllowInsecureConnections -Name "banuget" -Source "http://192.168.1.7:8500/v3/index.json"
```

## 清除包缓存

方法一：删除目录：%UserProfile%\.nuget\packages\ 下对应的包文件

方法二：执行命令`nuget locals all -clear`

## 如何确认已安装的包源

查看%UserProfile%\.nuget\packages\\furion\4.9.7.55\.nupkg.metadata文件，source应为："http://192.168.1.7:8500/v3/index.json"

```json
{
  "version": 2,
  "contentHash": "YitEA68tDrT1o+NlTAaKKx4rvWEhqUB/YOPx5miKnHzoXmNVNDl4gt2SwMQGOYyxcqbYAQ430ULOu6J5er6XVA==",
  "source": "http://192.168.1.7:8500/v3/index.json"
}
```

## 使用配置文件

在项目文件夹中创建NuGet.Config文件

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>  
    <packageSources>
        <clear />
        <add key="banuget" value="http://192.168.1.7:8500/v3/index.json" allowInsecureConnections="true"/>
        <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
    </packageSources>
    <packageSourceMapping>
        <packageSource key="banuget">
            <package pattern="指定的包名(可用通配符，有需要从官网获取依赖的包这样不行)" />
        </packageSource>
    </packageSourceMapping>
</configuration>
```

