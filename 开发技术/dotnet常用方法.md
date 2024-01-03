# dotnet常用方法

## 打印excel

* 运行环境：.NET Framwork 4.6.2
* Nuget包依赖：
  * Microsoft.Office.Interop.Excel
* 其它依赖：
  * 需安装Excel

```csharp
using Excel = Microsoft.Office.Interop.Excel;
public class ExcelHelper
{
    static void Print(string excelFileName)
    {
        Excel.Application excelApp = new Excel.Application();

        // Open the Workbook:
        Excel.Workbook wb = excelApp.Workbooks.Open(excelFileName);

        // Get the first worksheet.
        // (Excel uses base 1 indexing, not base 0.)
        Excel.Worksheet ws = (Excel.Worksheet)wb.Worksheets[1];

        // Print out 1 copy to the default printer:
        //ws.PrintOut("起始页号", "结束页号", "打印份数", "False", "打印机名", "False", Type.Missing, Type.Missing);
        ws.PrintOut(Type.Missing, Type.Missing, "1", "False", "Microsoft XPS Document Writer", "False", Type.Missing, Type.Missing);

        // Cleanup:
        GC.Collect();
        GC.WaitForPendingFinalizers();

        Marshal.FinalReleaseComObject(ws);

        wb.Close(false, Type.Missing, Type.Missing);
        Marshal.FinalReleaseComObject(wb);

        excelApp.Quit();
        Marshal.FinalReleaseComObject(excelApp);
    }
}
```

## AES加密解密

* 运行环境：.NET Framwork 4.6.2
* Nuget包依赖：
* 其它依赖：

```csharp
public class SecurityHelper
{
    private static readonly byte[] _Key = Encoding.UTF8.GetBytes("gWs3K16Ncmt04TcsMOY4eHLYNd3HOZPn"); // 16, 24, or 32 characters for AES-128, AES-192, or AES-256
    private static readonly byte[] _IV = Encoding.UTF8.GetBytes("rmX06gGYL8Me2QNy"); // 16 characters for AES
    public static byte[] AesEncryptBytes(byte[] data)
    {
        using (Aes aesAlg = Aes.Create())
        using (ICryptoTransform encryptor = aesAlg.CreateEncryptor(_Key, _IV))
        using (var ms = new MemoryStream())
        using (var cs = new CryptoStream(ms, encryptor, CryptoStreamMode.Write))
        {
            cs.Write(data, 0, data.Length);
            cs.FlushFinalBlock();
            cs.Close();
            return ms.ToArray();
        }
    }
    public static byte[] AesDecryptBytes(byte[] data)
    {
        using (Aes aesAlg = Aes.Create())
        using (ICryptoTransform decryptor = aesAlg.CreateDecryptor(_Key, _IV))
        using (var ms = new MemoryStream())
        using (var cs = new CryptoStream(ms, decryptor, CryptoStreamMode.Write))
        {
            cs.Write(data, 0, data.Length);
            cs.FlushFinalBlock();
            cs.Close();
            return ms.ToArray();
        }
    }
}
```

## 计算运行时长

* 运行环境：.NET Framwork 4.6.2
* Nuget包依赖：
* 其它依赖：

```csharp
Stopwatch sw = new Stopwatch();
sw.Start();

//要计算耗时的代码

sw.Stop();
TimeSpan ts = sw.Elapsed;
Console.WriteLine("代码运行总共花费{0}ms.", ts.TotalMilliseconds);
```

## 程序请求管理员权限运行

* 运行环境：.NET Framwork 4.6.2
* Nuget包依赖：
* 其它依赖：

```csharp
// 1. 在解决方案管理器中，Properties上点鼠标右键添加新建项，选择“应用程序清单文件”
// 2. 打开应用程序清单文件：app.manifest，修改下面的代码，将asInvoker替换为requireAdministrator
<requestedExecutionLevel level="asInvoker" uiAccess="false" />
```

## 线程执行任务超时取消

* 运行环境：.NET Framwork 4.6.2
* Nuget包依赖：
* 其它依赖：

```csharp
CancellationTokenSource TaskCancellationToken = new CancellationTokenSource();
var t = Task.Factory.StartNew(() => {
    //线程中要运行的代码
});
int Timeout = 6 * 1000;//60秒超时时间
if (!t.Wait(Timeout, TaskCancellationToken.Token))
{
    //线程已经超时 取消线程
    TaskCancellationToken.Cancel();
}
```

## 同时运行多个线程任务并等待所有线程运行结束

* 运行环境：.NET Framwork 4.6.2
* Nuget包依赖：
* 其它依赖：

```csharp
async Task Main()
{
    List<Task> t = new List<Task>();
    for (int i=0;i<10;i++)
    {
        t.Add(RunSomething(i));
    }
    await Task.WhenAll(t);
}
async Task RunSomething(int i)
{
    await Task.Delay(1000 + i * 100);
    Console.WriteLine($"{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff")} Task {i} is finished");
}
```
