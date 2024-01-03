# 打印excel

* 需安装excel
* 引入Nuget包：Microsoft.Office.Interop.Excel

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
