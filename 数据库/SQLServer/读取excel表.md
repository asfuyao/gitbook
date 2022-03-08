# 在sql server的查询分析器中读取excel数据

参考网址：https://docs.microsoft.com/zh-cn/sql/relational-databases/import-export/import-data-from-excel-to-sql?view=sql-server-ver15

## 启用组件

```sql
--启用
sp_configure 'show advanced options', 1;
RECONFIGURE;
GO
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

--关闭
sp_configure 'show advanced options', 0;
RECONFIGURE;
GO
sp_configure 'Ad Hoc Distributed Queries', 0;
RECONFIGURE;
GO
```

## 查询方法

```sql
--方法一
SELECT * INTO Data_dq
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0; Database=C:\Temp\Data.xlsx', [Sheet1$]);

--方法二
SELECT * INTO Data_dq
FROM OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0',
    'Data Source=C:\Temp\Data.xlsx;Extended Properties=Excel 12.0')...[Sheet1$];
```

## 常见错误

### Microsoft.ACE.OLEDB.12.0 尚未注册

发生此错误的原因是未安装 OLEDB 提供程序。 请通过 [Microsoft Access 数据库引擎 2010 可再发行组件](https://www.microsoft.com/download/details.aspx?id=13255)进行安装。 如果 Windows 和 SQL Server 都是 64 位，请务必安装 64 位版本。

### 无法为链接服务器 "(null)" 创建 OLE DB 提供程序 "Microsoft.ACE.OLEDB.12.0" 的实例

这表示 Microsoft OLEDB 配置错误。 运行以下 Transact-SQL 代码可解决此问题：

```sql
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
```

### 文件未放在sqlserver所在服务器上

会报下面错误：

* 链接服务器 "(null)" 的 OLE DB 访问接口 "Microsoft.ACE.OLEDB.12.0" 报错。提供程序未给出有关错误的任何信息。
* 无法初始化链接服务器“(null)”的 OLE DB 访问接口“Microsoft.ACE.OLEDB.12.0”的数据源对象。

解决办法：

把excel放服务器上即可
