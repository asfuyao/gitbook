# 表类型方法

```csharp
public static void SqlBatchInsertByDataTable(DataTable dt, string tableName, string tableTypeName, SqlTransaction transaction)
{            
    string columnsStr = string.Join(",", dt.Columns.Cast<DataColumn>().ToList().Select(o => o.ColumnName).ToArray());

    string sqlStr = $@"INSERT INTO {tableName} ({columnsStr})
                       SELECT {columnsStr} from @dataTable";

    using (SqlCommand sqlCmd = new SqlCommand(sqlStr, transaction.Connection))
    {
        SqlParameter sqlPar = sqlCmd.Parameters.AddWithValue("@dataTable", dt);
        sqlPar.SqlDbType = SqlDbType.Structured;
        sqlPar.TypeName = tableTypeName;//表值参数名称
        sqlCmd.Transaction = transaction;
        sqlCmd.ExecuteNonQuery();
    }
}
```



# SqlBulkCopy方法

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

