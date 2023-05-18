# BaGet部署

创建docker-complse.yml文件，并执行`docker-compose up -d`部署

```yml
version: "3.3"
services:
  baget:
    image: loicsharma/baget:latest
    container_name: nuget-server
    restart: always
    environment:
      - SA_PASSWORD=P@ssw0rd
      - ApiKey=WfBieNith!GFkLL5V3h0KoOClILE #key字符串，上传包的时候有用
      - Storage__Type=FileSystem
      - Storage__Path=/var/baget/packages
      - Database__Type=Sqlite
      - Database__ConnectionString=Data Source=/var/baget/baget.db
      - Search__Type=Database
    ports:
      - 5555:80
    volumes:
      - ./data:/var/baget
```

# 创建一个简单的nuget包

## 创建新项目

* 项目类型：类库
* 编译dll
* 创建nuget文件夹，复制编译好的dll到此目录
* 在目录下放Icon.png文件
* 在目录下放readme.md文件

## 下载nuget

到网站https://www.nuget.org/downloads下载nuget.exe

或者通过scoop安装：scoop install nuget

## 创建Package.nuspec文件

执行nuget spec生成Package.nuspec文件，编辑文件修改如下

```xml
<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://schemas.microsoft.com/packaging/2012/06/nuspec.xsd">
  <metadata>
    <id>Package</id>
    <version>1.0.0</version>
    <authors>fuyao</authors>
    <owners></owners>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <license type="expression">MIT</license>
    <icon>Icon.png</icon>
    <readme>readme.md</readme>
    <description>SerialPortHelper</description>
    <releaseNotes></releaseNotes>
    <copyright>$copyright$</copyright>
    <tags></tags>
    <dependencies>
      <group targetFramework=".NETStandard2.1">
        <dependency id="SampleDependency" version="1.0.0" />
      </group>
    </dependencies>
  </metadata>
  <files>
    <file src="SerialPortHelper.dll" target="SerialPortHelper.dll" />
    <file src="Icon.png" target="Icon.png" />
    <file src="readme.md" target="readme.md" />
  </files>
</package>
```

## 生成nuget包

执行nuget pack生成nuget包

## 上传nuget包

dotnet nuget push -s http://服务器IP:5555/v3/index.json -k WfBieNith!GFkLL5V3h0KoOClILE Package.1.0.0.nupkg