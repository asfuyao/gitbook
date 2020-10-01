<!-- TOC -->

- [1. GridControl](#1-gridcontrol)
    - [1.1. 显示小计项目](#11-显示小计项目)
    - [1.2. GridView单元格内容换行](#12-gridview单元格内容换行)
    - [1.3. GridControl内容打印](#13-gridcontrol内容打印)
    - [1.4. 合并单元格](#14-合并单元格)
    - [1.5. 隔行显示不同颜色](#15-隔行显示不同颜色)
    - [1.6. GridView自动列宽](#16-gridview自动列宽)
    - [1.7. 显示横线滚动条](#17-显示横线滚动条)
    - [1.8. 复制单元格内容到剪贴板](#18-复制单元格内容到剪贴板)
    - [1.9. 获取选择行的某列内容](#19-获取选择行的某列内容)
    - [1.10. 显示过滤面板](#110-显示过滤面板)
    - [1.11. 显示行号](#111-显示行号)
    - [1.12. 在GridView中增加行号](#112-在gridview中增加行号)
    - [1.13. BarManager中交点漂移问题](#113-barmanager中交点漂移问题)
    - [1.14. 显示格式说明](#114-显示格式说明)
        - [1.14.1. 数字](#1141-数字)
        - [1.14.2. 日期](#1142-日期)
        - [1.14.3. 格式设置](#1143-格式设置)

<!-- /TOC -->

# 1. GridControl

## 1.1. 显示小计项目

```csharp
//可放到FormLoad事件中执行
DevExpress.XtraGrid.Views.Grid.GridView gridView = gridView1;//获取GridView
if (gridView != null)
{
    string groupColmn = "分组列";
    DevExpress.XtraGrid.Columns.GridColumn gridColumn = gridView.Columns[groupColmn];
    if (gridColumn != null)
    {
        gridColumn.GroupIndex = 0; //设置分组的列
    }

    string sumColumn = "列名1";
    //在GroupFooter上显示汇总小计项
    gridView.GroupSummary.Add(DevExpress.Data.SummaryItemType.Sum, sumColumn, gridView.Columns[sumColumn]);//指定在具体的列下面显示小计
    gridView.GroupSummary[gridView.GroupSummary.Count - 1].DisplayFormat = "汇总小计：{0:N2}";//N2是带千分位并保留两位小数的格式
    //在GroupHead上显示汇总小计项
    gridView.GroupSummary.Add(DevExpress.Data.SummaryItemType.Sum, sumColumn);
    gridView.GroupFormat = "[#image]{1}";//默认"{0}: [#image]{1} {2}"; 字段名称：数据 计数=？
    //在GroupFooter上显示行数小计项
    string countCloumn = "列名2";
    gridView.GroupSummary.Add(DevExpress.Data.SummaryItemType.Count, countCloumn, gridView.Columns[countCloumn]);
    gridView.GroupSummary[gridView.GroupSummary.Count - 1].DisplayFormat = "行数小计：{0}";
    //
    gridView.OptionsBehavior.AutoExpandAllGroups = true;//是否自动展开所有组

    gridView.OptionsView.ShowGroupedColumns = false;//是否显示分组的列
}
```

## 1.2. GridView单元格内容换行

```csharp
{
    string wrapColumn = "要折行显示的列名";
    DevExpress.XtraGrid.Columns.GridColumn gridColumn = gridView.Columns[wrapColumn];
    if (gridColumn != null)
    {
        gridView.Columns[wrapColumn].ColumnEdit = new RepositoryItemMemoEdit() { WordWrap = true, AutoHeight = true };
        gridView.OptionsView.RowAutoHeight = true;
    }
}
```



## 1.3. GridControl内容打印

```csharp
private void GridPrint()
{
    PrintingSystem print = new PrintingSystem();
    PrintableComponentLink link = new PrintableComponentLink(print);
    print.Links.Add(link);
    link.Component = gridControl1;
    print.ShowPrintStatusDialog = true;

    link.PaperKind = System.Drawing.Printing.PaperKind.A3; //设置纸型  
    link.Landscape = true; //是否横向打印
    link.Margins = new System.Drawing.Printing.Margins(30, 30, 100, 50); //设置页边距（左、右、上、下）

    string _PrintHeaderLeft = "\r\n \r\n \r\n 统计时间：" + DateTime.Parse(dateEdit1.Text.ToString()).ToString("yyyy-MM-dd HH:mm:ss") + " 至 " + DateTime.Parse(dateEdit2.Text.ToString()).ToString("yyyy-MM-dd HH:mm:ss");
    string _PrintHeaderRight = "\r\n \r\n \r\n 药房：" + this.DeptName;

    string _PrintFooterLeft = "打印人：" + PlatCommon.SysBase.SystemParm.LoginUser.NAME;
    string _PrintFooterRight = "打印时间：" + PlatCommon.Common.PublicFunction.GetSysDate();

    PageHeaderFooter phf = link.PageHeaderFooter as PageHeaderFooter;
    //打印页头
    phf.Header.Content.Clear();
    phf.Header.Content.AddRange(new string[] { _PrintHeaderLeft, "", _PrintHeaderRight });
    phf.Header.Font = new Font("宋体", 11, FontStyle.Bold);
    phf.Header.LineAlignment = BrickAlignment.Center;

    //打印页头的另一个方法
    link.CreateMarginalHeaderArea += new CreateAreaEventHandler(link_CreateMarginalHeaderArea);

    //打印页尾
    phf.Footer.Content.Clear();
    phf.Footer.Content.AddRange(new string[] { _PrintFooterLeft, "", _PrintFooterRight });
    phf.Footer.Font = new Font("宋体", 10, FontStyle.Bold);
    phf.Footer.LineAlignment = BrickAlignment.Center;

    //打印页尾的另一个方法
    link.CreateMarginalFooterArea += new CreateAreaEventHandler(link_CreateMarginalFooterArea);

    link.CreateDocument(); //建立文档  
    link.ShowPreviewDialog();
}
void link_CreateMarginalHeaderArea(object sender, CreateAreaEventArgs e)
{
    PageInfoBrick vPageInfoBrick1 = e.Graph.DrawPageInfo(PageInfo.None, this.Text, Color.Black, new RectangleF(0, 0, 100, 21), BorderSide.None);
    vPageInfoBrick1.LineAlignment = BrickAlignment.Center;
    vPageInfoBrick1.Alignment = BrickAlignment.Center;
    vPageInfoBrick1.AutoWidth = true;
    vPageInfoBrick1.Font = new System.Drawing.Font("宋体", 18, FontStyle.Bold);
}

void link_CreateMarginalFooterArea(object sender, CreateAreaEventArgs e)
{
    PageInfoBrick vPageInfoBrick1 = e.Graph.DrawPageInfo(PageInfo.NumberOfTotal, "第{0}页，共{1}页", Color.Black, new RectangleF(0, 0, 100, 21), BorderSide.None);
    vPageInfoBrick1.LineAlignment = BrickAlignment.Center;
    vPageInfoBrick1.Alignment = BrickAlignment.Center;
    vPageInfoBrick1.AutoWidth = true;
    vPageInfoBrick1.Font = new System.Drawing.Font("宋体", 11f, FontStyle.Bold);
}
```

## 1.4. 合并单元格

```csharp
gridView.OptionsView.AllowCellMerge = true; //设置允许合并单元格，整体控制选项
gridView.Columns["列名"].OptionsColumn.AllowMerge = DevExpress.Utils.DefaultBoolean.False; //设置不想合并的具体列
```

## 1.5. 隔行显示不同颜色

```csharp
gridView.OptionsView.EnableAppearanceEvenRow = true;  //允许偶数行显示背景色
gridView.OptionsView.EnableAppearanceOddRow = true;  //允许奇数行显示背景色
```

## 1.6. GridView自动列宽

```csharp
gridview1.BestFitColumns();
```

## 1.7. 显示横线滚动条

```csharp
//由于设置了自动列宽因此不会出现滚动条，将自动列宽设置为false即可
gridView1.OptionsView.ColumnAutoWidth = false;
```

## 1.8. 复制单元格内容到剪贴板

```csharp
private void gridView1_KeyDown(object sender, KeyEventArgs e)
{
    if (e.Control & e.KeyCode == Keys.C)
    {
        Clipboard.SetDataObject(gridView1.GetFocusedRowCellValue(gridView1.FocusedColumn));
        e.Handled = true;
    }
}
```

## 1.9. 获取选择行的某列内容

```csharp
gridView1.GetFocusedRowCellValue(gridView1.Columns["列名"]).ToString()
```

## 1.10. 显示过滤面板

```csharp
//显示过滤面板
gridView.OptionsView.ShowAutoFilterRow = true;
//指定列的筛选条件
gridView.Columns["列名"].OptionsFilter.AutoFilterCondition = DevExpress.XtraGrid.Columns.AutoFilterCondition.Equals;
```

## 1.11. 显示行号

```csharp
//在FormLoad中设置行号宽
gridView1.IndicatorWidth = 50;

//设置宽度并绑定事件
gridView1.IndicatorWidth = 50; //设置指示兰宽度
gridView1.CustomDrawRowIndicator += new DevExpress.XtraGrid.Views.Grid.RowIndicatorCustomDrawEventHandler(GridViewDrawRowNumber);
//填充序号事件
private void GridViewDrawRowNumber(object sender, DevExpress.XtraGrid.Views.Grid.RowIndicatorCustomDrawEventArgs e)
{
    if (e.Info.IsRowIndicator && e.RowHandle >= 0)
    {
        e.Info.DisplayText = (e.RowHandle + 1).ToString();
    }
}
```

## 1.12. 在GridView中增加行号

```csharp
//假设第一列为序号列，可在sql语句中增加一个值为空字符串的列，然后在数据填充后用下面语句增加行号
for (int i = 0; i < gridView1.RowCount; i++)
{
    gridView1.SetRowCellValue(i, gridView1.Columns[0], (i + 1).ToString());
}
```

## 1.13. BarManager中交点漂移问题

在BarManger中的按钮前面添加RadioGroup控件后点击选择发生焦点漂移的问题，焦点飘到后面的按钮上了，解决办法是把RadioGroup后面的按钮设置为Begin a Group。
目前测试发现这个办法不一定好用，原因不明

## 1.14. 显示格式说明

### 1.14.1. 数字

字母后数字表示保留几位小数，无数字默认为2

* f,f0,f1,f2,f3，浮点数
* n,n0,n1,n2,n3，含千分位的浮点数
* d，整数
* P,P0,P1,P2,P3，百分比，直接在数字后面添加百分号
* p,p0,p1,p2,p3，百分比，值为小数，乘100后添加百分号

### 1.14.2. 日期

* G yyyy/MM/dd hh:mm:ss
* g yyyy/MM/dd hh:mm
* T hh:mm:ss
* t hh:mm

### 1.14.3. 格式设置

```csharp
//设置列显示格式
gridView.Columns["列名"].AppearanceCell.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
gridView.Columns["列名"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
gridView.Columns["列名"].DisplayFormat.FormatString = "N2";
//设置汇总显示格式
gridView.Columns["列名"].SummaryItem.DisplayFormat = "{0:N2}";
```
