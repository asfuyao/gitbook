<!-- TOC -->

- [GridControl](#gridcontrol)
    - [显示小计项目](#显示小计项目)
    - [GridView单元格内容换行](#gridview单元格内容换行)
    - [GridControl内容打印](#gridcontrol内容打印)
    - [合并单元格](#合并单元格)
    - [隔行显示不同颜色](#隔行显示不同颜色)
    - [GridView自动列宽](#gridview自动列宽)
    - [显示格式说明](#显示格式说明)
        - [数字](#数字)

<!-- /TOC -->

# GridControl

## 显示小计项目

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

## GridView单元格内容换行

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



## GridControl内容打印

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

## 合并单元格

```csharp
gridView.OptionsView.AllowCellMerge = true; //设置允许合并单元格，整体控制选项
gridView.Columns["列名"].OptionsColumn.AllowMerge = DevExpress.Utils.DefaultBoolean.False; //设置不想合并的具体列
```

## 隔行显示不同颜色

```csharp
gridView.OptionsView.EnableAppearanceEvenRow = true;  //允许偶数行显示背景色
gridView.OptionsView.EnableAppearanceOddRow = true;  //允许奇数行显示背景色
```

## GridView自动列宽

```csharp
gridview1.BestFitColumns();
```

## 显示格式说明

### 数字

字母后数字表示保留几位小数，无数字默认为2

* f,f0,f1,f2,f3，浮点数
* n,n0,n1,n2,n3，小数
* d，整数
* P,P0,P1,P2,P3，百分比，直接在数字后面添加百分号
* p,p0,p1,p2,p3，百分比，值为小数，乘100后添加百分号