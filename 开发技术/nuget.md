# 常用操作

## 创建私有的NuGet包源

* 下载BaGet：https://github.com/loic-sharma/BaGet/releases
* 解压缩到固定文件夹，修改配置文件：appsettings.json，类似下面的配置

```json
{
  "ApiKey": "P@ssw0rd", // 客户端发布包到服务器时需要的key，随意设置
  "PackageDeletionBehavior": "Unlist",
  "AllowPackageOverwrites": true, // 是否允许覆盖已有包

  "Database": {
    "Type": "Sqlite",
    "ConnectionString": "Data Source=baget.db"
  },

  "Storage": {
    "Type": "FileSystem",
    "Path": "S:/NugetServer/package" // 包文件存放位置
  },

  "Search": {
    "Type": "Database"
  },

  "Mirror": {
    "Enabled": false,
    // Uncomment this to use the NuGet v2 protocol
    //"Legacy": true,
    "PackageSource": "https://api.nuget.org/v3/index.json"
  },

  // Uncomment this to configure BaGet to listen to port 8080.
  // See: https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel?view=aspnetcore-3.1   #listenoptionsusehttps
  "Kestrel": {
    "Endpoints": {
      "Http": {
        "Url": "http://*:8500" // 程序监听端口
      }
    }
  },

  "Logging": {
    "IncludeScopes": false,
    "Debug": {
      "LogLevel": {
        "Default": "Warning"
      }
    },
    "Console": {
      "LogLevel": {
        "Microsoft.Hosting.Lifetime": "Information",
        "Default": "Warning"
      }
    }
  }
}

```

* 运行程序：`dotnet BaGet.dll`
* 可通过http://IP地址:端口号查看已上传的包

## 推送包到私有服务器

### 创建配置文件(可选)

如果是http类型的私有源，需要在推送脚本所在的目录创建一个NuGet.Config文件，用来跳过安全检查

```xml
<configuration>
  <packageSources>
    <add key="InsecureSource" value="http://192.168.1.7:8500/v3/index.json" allowInsecureConnections="true" />
  </packageSources>
</configuration>
```

### 推送脚本

创建脚本文件：nuget-push.ps1

```powershell
# 定义参数
Param(
    # NuGet APIKey
    [string] $apikey = "P@ssw0rd" #与服务器设置保持一致
)

Write-Warning "正在发布 framework 目录 NuGet 包......";

# 查找 .\framework\nupkgs 下所有目录
cd .\framework\nupkgs;
$framework_nupkgs = Get-ChildItem -Filter *.nupkg;

# 遍历所有 *.nupkg 文件
for ($i = 0; $i -le $framework_nupkgs.Length - 1; $i++){
    $item = $framework_nupkgs[$i];

    $nupkg = $item.FullName;
    $snupkg = $nupkg.Replace(".nupkg", ".snupkg");

    Write-Output "-----------------";
    $nupkg;

    # 发布到 nuget.org 平台
    dotnet nuget push $nupkg --skip-duplicate --api-key $apikey --source http://192.168.1.7:8500/v3/index.json;
    dotnet nuget push $snupkg --skip-duplicate --api-key $apikey --source http://192.168.1.7:8500/v3/index.json;

    Write-Output "-----------------";
}

# 回到项目根目录
cd ../../;

Write-Warning "发布成功";
```



## 程序包源管理

### 配置文件位置

编辑或新建NuGet.Config，文件位置分为以下几种：

#### 1. 用户级别

- **位置**：`%APPDATA%\NuGet\NuGet.Config`（Windows）或`~/.nuget/NuGet/NuGet.Config`（macOS/Linux）。
- **作用范围**：对当前用户的所有项目生效。
- **说明**：这是最常用的配置文件位置，适用于个人开发环境的全局设置。
- **GUI方式编辑**：VS菜单 -> 工具 -> 选项 -> NuGet包管理器 -> 程序包源

####  2. **解决方案级别**

- **位置**：解决方案文件（`.sln`）所在的目录。
- **作用范围**：仅对当前解决方案中的所有项目生效。
- **说明**：如果多个项目属于同一个解决方案，并且需要统一的 NuGet 配置，可以将 `NuGet.Config` 文件放在解决方案根目录下。

#### 3. **项目级别**

- **位置**：项目文件（`.csproj`、`.vbproj` 等）所在的目录。
- **作用范围**：仅对当前项目生效。
- **说明**：如果需要为某个特定项目设置独特的 NuGet 配置，可以将 `NuGet.Config` 文件放在项目根目录下。

#### 4. **机器级别**

- **位置**：`%ProgramFiles(x86)%\NuGet\Config`（Windows）。
- **作用范围**：对所有用户的所有项目生效。
- **说明**：这种配置文件通常由系统管理员设置，适用于整个开发环境的全局配置。

#### 5. **环境变量级别**

- **位置**：通过环境变量 `NUGET_CONFIG` 指定路径。
- **作用范围**：根据环境变量的设置生效。
- **说明**：可以通过设置环境变量来指定特定的 `NuGet.Config` 文件路径，适用于需要灵活配置的场景。

### 配置文件样例

* 注意源的顺序，软件包加载是按源的顺序查找！
* http的源需要添加：allowInsecureConnections="true"
* 标记<clear />为可选项，通常在解决方案或项目级别添加，用来清除现有的包源

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>    
    <clear />
    <add key="banuget" value="http://192.168.1.7:8500/v3/index.json" allowInsecureConnections="true"/>
    <add key="Microsoft Visual Studio Offline Packages" value="C:\Program Files (x86)\Microsoft SDKs\NuGetPackages\" />
    <add key="FastReport.NET.WinForms.Pack" value="D:\Software\Developer\FastReport.nupkg" />
    <add key="FastReport.NET.WinForms.Pack.2025.2.1" value="C:\Program Files (x86)\Fast Reports\.NET\2025.2.1\FastReport .NET WinForms Pack\Nugets" />
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
  </packageSources>
</configuration>
```



## 清除包缓存

方法一：删除目录：`%UserProfile%\.nuget\packages\` 下对应的包文件

方法二：执行命令：`nuget locals all -clear`

## 如何确认已安装的包源

查看%UserProfile%\.nuget\packages\\furion\4.9.7.55\.nupkg.metadata文件，source应为："http://192.168.1.7:8500/v3/index.json"

```json
{
  "version": 2,
  "contentHash": "YitEA68tDrT1o+NlTAaKKx4rvWEhqUB/YOPx5miKnHzoXmNVNDl4gt2SwMQGOYyxcqbYAQ430ULOu6J5er6XVA==",
  "source": "http://192.168.1.7:8500/v3/index.json"
}
```