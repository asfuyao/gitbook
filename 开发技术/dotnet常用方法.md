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
void Main()
{
    List<Task> t = new List<Task>();
    for (int i=0;i<10;i++)
    {
        t.Add(RunSomething(i));
    }
    await Task.WhenAll(t);
    //Task.WaitAll(t.ToArray()); 可选运行方式，与上条语句等价
}
async Task RunSomething(int i)
{
    await Task.Delay(1000 + i * 100);
    Console.WriteLine($"{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff")} Task {i} is finished");
}
```

## WinForm程序限制只能运行一次和全局异常捕获

* 运行环境：.NET Framwork 4.6.2
* Nuget包依赖：
* 其它依赖：

```csharp
using System;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Windows.Forms;

namespace WebPrintService
{
    static class Program
    {
        private static Mutex mutex;

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            try
            {
                //设置应用程序处理异常方式：ThreadException处理
                Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);
                //处理UI线程异常
                Application.ThreadException += new ThreadExceptionEventHandler(Application_ThreadException);
                //处理非UI线程异常
                AppDomain.CurrentDomain.UnhandledException += new UnhandledExceptionEventHandler(CurrentDomain_UnhandledException);

                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);

                mutex = new Mutex(true, "D7A78C74-5BA6-4181-99D5-3F7A10A21CF3"); //程序UUID，注意不要和其它程序重复，保持唯一即可
                if (mutex.WaitOne(0, false))
                {
                    AppDomain.CurrentDomain.AssemblyResolve += new ResolveEventHandler(CurrentDomain_AssemblyResolve);
                    Application.Run(new FMain()); //主窗体
                }
                else
                {
                    //MessageBox.Show("程序已经在运行！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    Application.Exit();
                }
            }
            catch (Exception ex)
            {
                string str = GetExceptionMsg(ex, string.Empty);
                MessageBox.Show(str, "系统错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        private static System.Reflection.Assembly CurrentDomain_AssemblyResolve(object sender, ResolveEventArgs args)
        {
            string assName = new AssemblyName(args.Name).Name;
            string resName = assName + ".dll";


            using (var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(resName))
            {
                if (stream == null)
                {
                    return null;
                }
                Byte[] assemblyData = new Byte[stream.Length];
                stream.Read(assemblyData, 0, assemblyData.Length);
                return Assembly.Load(assemblyData);
            }
        }
        static void Application_ThreadException(object sender, ThreadExceptionEventArgs e)
        {
            string str = GetExceptionMsg(e.Exception, e.ToString());
            MessageBox.Show(str, "系统错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        static void CurrentDomain_UnhandledException(object sender, UnhandledExceptionEventArgs e)
        {
            string str = GetExceptionMsg(e.ExceptionObject as Exception, e.ToString());
            MessageBox.Show(str, "系统错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        // <summary>
        /// 生成自定义异常消息
        /// </summary>
        /// <param name="ex">异常对象</param>
        /// <param name="backStr">备用异常消息：当ex为null时有效</param>
        /// <returns>异常字符串文本</returns>
        static string GetExceptionMsg(Exception ex, string backStr)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("****************************异常文本****************************");
            sb.AppendLine("【出现时间】：" + DateTime.Now.ToString());
            if (ex != null)
            {
                sb.AppendLine("【异常类型】：" + ex.GetType().Name);
                sb.AppendLine("【异常信息】：" + ex.Message);
                sb.AppendLine("【堆栈调用】：" + ex.StackTrace);
            }
            else
            {
                sb.AppendLine("【未处理异常】：" + backStr);
            }
            sb.AppendLine("***************************************************************");
            return sb.ToString();
        }
    }
}
```

## 限制同步运行Task的数量

* 运行环境：.NET Framwork 4.6.2
* Nuget包依赖：
* 其它依赖：

```csharp
void Main()
{
    var allTasks = Enumerable.Range(1, 100).Select(id => DoWorkAsync(id));
    //await Task.WhenAll(tasks);
    Task.WaitAll(allTasks.ToArray());
}

readonly SemaphoreSlim _mutex = new SemaphoreSlim(5); //限制任务数量

async Task DoWorkAsync(int id)
{
    await _mutex.WaitAsync();
    try
    {
        await Task.Delay(20000);
        Console.WriteLine($"{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff")} Task {id} is finished");
    }
    finally
    {
        _mutex.Release();
    }
}
```

## 通过互斥锁将并行操作改为串行

* 运行环境：.NET Framwork 4.6.2
* Nuget包依赖：
* 其它依赖：

```csharp
private static Mutex mutex = new Mutex();

public string getSerial()
{
    mutex.WaitOne();

    // 执行获取序号方法
    // Task.Delay(5000).Wait(); //模拟任务执行

    mutex.ReleaseMutex();

    return "返回序号";
}
```

