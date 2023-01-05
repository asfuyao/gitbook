# sql数据批量插入方法
## 表类型方法

```csharp
public static void SqlBatchInsertByDataTable(DataTable dt, string tableName, string tableTypeName, SqlTransaction transaction)
{            
    string columnsStr = string.Join(",", dt.Columns.Cast<DataColumn>().Select(o => o.ColumnName).ToArray());

    string sqlStr = $@"INSERT INTO {tableName} ({columnsStr})
                       SELECT {columnsStr} from @dataTable";	
    
    //数据插入
    using (SqlCommand sqlCmd = new SqlCommand(sqlStr, transaction.Connection))
    {
        SqlParameter sqlPar = sqlCmd.Parameters.AddWithValue("@dataTable", dt);
        sqlPar.SqlDbType = SqlDbType.Structured;
        sqlPar.TypeName = "tableTypeName";//表值参数名称
        sqlCmd.Transaction = transaction;
        sqlCmd.ExecuteNonQuery();
    }
    
    string sqlSelect = $@"
                        SELECT DISTINCT a.CategoryCode
                        FROM   dbo.MesMMCode a
                        INNER  JOIN @dataTable b on b.MaterialCode = a.MaterialCode
                        WHERE  NOT EXISTS ( SELECT *
                                            FROM   dbo.MesMMCategory
                                            WHERE  CategoryCode = a.CategoryCode )";
    //数据读取，含事务
    List<string> list = new List<string>();
    using (SqlCommand sqlCmd = new SqlCommand(sqlSelect, transaction.Connection, transaction))
    {
        SqlParameter sqlPar = sqlCmd.Parameters.AddWithValue("@dataTable", dt);
        sqlPar.SqlDbType = SqlDbType.Structured;
        sqlPar.TypeName = "tableTypeName";//表值参数名称
        var sdr = sqlCmd.ExecuteReader();
        while (sdr.Read())
        {
            list.Add(sdr["列名"].ToString());
        }
        sdr.Close();
    }
}
```



## SqlBulkCopy方法

```c#
public static void SqlBulkCopyByDataTable(DataTable dt, string tableName, SqlTransaction transaction)
{
    using (SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(transaction.Connection, SqlBulkCopyOptions.Default, transaction))
    {
        sqlBulkCopy.BatchSize = dt.Rows.Count;    //分批提交记录数，可不设
        sqlBulkCopy.BulkCopyTimeout = 10;    //超时时间设置
        sqlBulkCopy.DestinationTableName = tableName;    // 设置目标表名称

        //列映射（可选）
        //sqlBulkCopy.ColumnMappings.Add("ID", "ID");
        //sqlBulkCopy.ColumnMappings.Add("Num", "Num");
        //sqlBulkCopy.ColumnMappings.Add("Name", "Name");
        //sqlBulkCopy.ColumnMappings.Add("Age", "Age");
                        
        sqlBulkCopy.WriteToServer(dt); //全部写入数据库
    }
}
```

# 通过Stream提交post数据（支持body）

```c#
public static T HttpPost<T>(string baseUrl,
        IReadOnlyDictionary<string, string> headers,
        IReadOnlyDictionary<string, string> urlParas,
        string requestBody = null)
{
    var resuleJson = string.Empty;
    try
    {
        var apiUrl = baseUrl;

        if (urlParas != null)
            foreach (var p in urlParas)
            {
                if (apiUrl.IndexOf("{" + p.Key + "}") > -1)
                {
                    apiUrl = apiUrl.Replace("{" + p.Key + "}", p.Value);
                }
                else
                {
                    apiUrl += string.Format("{0}{1}={2}", apiUrl.Contains("?") ? "&" : "?", p.Key, p.Value);
                }
            }

        var req = (HttpWebRequest)WebRequest.Create(apiUrl);
        req.Method = "POST";
        req.ContentType = "application/json"; //Defalt

        if (!string.IsNullOrEmpty(requestBody))
        {
            using (var postStream = new StreamWriter(req.GetRequestStream()))
            {
                postStream.Write(requestBody);
            }
        }

        if (headers != null)
        {
            if (headers.Keys.Any(p => p.ToLower() == "content-type"))
                req.ContentType = headers.SingleOrDefault(p => p.Key.ToLower() == "content-type").Value;
            if (headers.Keys.Any(p => p.ToLower() == "accept"))
                req.Accept = headers.SingleOrDefault(p => p.Key.ToLower() == "accept").Value;
        }

        var response = (HttpWebResponse)req.GetResponse();

        using (Stream stream = response.GetResponseStream())
        {
            using (StreamReader reader = new StreamReader(stream, Encoding.GetEncoding("UTF-8")))
            {
                resuleJson = reader.ReadToEnd();
            }
        }
    }
    catch (Exception ex)
    {
        return default(T);
    }
    return JsonConvert.DeserializeObject<T>(resuleJson);
}
```

