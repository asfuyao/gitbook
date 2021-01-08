# dotnet命令基本操作

## 创建演示项目

```shell
# 创建目录
mkdir Demo
cd Demo
# 创建解决方案
dotnet new sln
# 创建webapi项目（不包含https、openapi）
dotnet new webapi --no-https --no-openapi -o Demo.Api
# 添加webapi项目到解决方案
dotnet sln add ./Demo.Api/Demo.Api.csproj
# 创建类库项目
dotnet new classlib -o Demo.Application
rm ./Demo.Application/Class1.cs
dotnet new classlib -o Demo.Domain
rm ./Demo.Domain/Class1.cs
# 添加类库到解决方案
dotnet sln add ./Demo.Application/Demo.Application.csproj
dotnet sln add ./Demo.Domain/Demo.Domain.csproj
# 为webapi项目添加两个项目引用
dotnet add ./Demo.Api/Demo.Api.csproj reference ./Demo.Application/Demo.Application.csproj ./Demo.Domain/Demo.Domain.csproj
# 向webapi项目添加包
cd Demo.Api
dotnet add package Furion
cd ..
# 向类库项目添加包
cd Demo.Domain
dotnet add package Newtonsoft.Json
dotnet add package FreeSql
dotnet add package FreeSql.Provider.SqlServer
dotnet add package FreeSql.Provider.MySql
cd ..
# 用vscode打开项目
code -r ../Demo
```

# Furino框架

安装Furino模板，并创建项目

```shell
dotnet new --install Furion.Template.Api
dotnet new furionapi -o Demo.Api
```

# FreeSql框架

## 数据库先行代码生成

```shell
# 安装 dotnet-tool 生成实体类
dotnet tool install -g FreeSql.Generator
# 查看使用帮助
FreeSql.Generator --help
# 使用示例，创建项目并生成sqlserver表和视图Model
dotnet new classlib -o BaseModel
cd BaseModel
dotnet add package Newtonsoft.Json
dotnet add package FreeSql
dotnet add package FreeSql.Provider.SqlServer
dotnet add package FreeSql.Provider.MySql
FreeSql.Generator -Razor 1 -NameOptions 0,0,0,0 -NameSpace BaseModel -DB "SqlServer,data source=39.99.202.122,51436;User ID=SQLD-UserDeve;Password=siemens;initial catalog=BA_Library_DB;pooling=true;max pool size=2" -Filter StoreProcedure
```



