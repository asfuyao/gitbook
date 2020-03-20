---
layout:     post
title:      Oracle和SQL Server的一些区别
subtitle:   数据库
date:       2020-01-14
author:     Winds
header-img: img/post-bg-hacker.jpg
catalog: true
tags:
    - Sql Server
    - Oracle
    - 数据库
---

>数据库 知识库
`https://blog.csdn.net/sqcwfiu/article/details/83285301`

<!-- TOC -->

- [1. Oracle和SQLServer实例对比](#1-oracle和sqlserver实例对比)
    - [1.1. 数学函数](#11-数学函数)
        - [1.1.1. 绝对值](#111-绝对值)
        - [1.1.2. 取整（大）](#112-取整大)
        - [1.1.3. 取整（小）](#113-取整小)
        - [1.1.4. 取整（截取）](#114-取整截取)
        - [1.1.5. 四舍五入](#115-四舍五入)
        - [1.1.6. e为底的幂](#116-e为底的幂)
        - [1.1.7. 取e为底的对数](#117-取e为底的对数)
        - [1.1.8. 取10为底对数](#118-取10为底对数)
        - [1.1.9. 取平方](#119-取平方)
        - [1.1.10. 取平方根](#1110-取平方根)
        - [1.1.11. 求任意数为底的幂](#1111-求任意数为底的幂)
        - [1.1.12. 取随机数](#1112-取随机数)
        - [1.1.13. 取符号](#1113-取符号)
        - [1.1.14. 圆周率](#1114-圆周率)
        - [1.1.15. 参数都以弧度为单位](#1115-参数都以弧度为单位)
        - [1.1.16. 返回弧度](#1116-返回弧度)
        - [1.1.17. 弧度角度互换](#1117-弧度角度互换)
        - [1.1.18. 求集合最大值](#1118-求集合最大值)
        - [1.1.19. 求集合最小值](#1119-求集合最小值)
        - [1.1.20. 如何处理null值](#1120-如何处理null值)
    - [1.2. 字符串函数](#12-字符串函数)
        - [1.2.1. 求字符序号](#121-求字符序号)
        - [1.2.2. 从序号求字符](#122-从序号求字符)
        - [1.2.3. 连接](#123-连接)
        - [1.2.4. 子串位置](#124-子串位置)
        - [1.2.5. 模糊查找子串的位置](#125-模糊查找子串的位置)
        - [1.2.6. 求子串](#126-求子串)
        - [1.2.7. 子串代替](#127-子串代替)
        - [1.2.8. 子串全部替换](#128-子串全部替换)
        - [1.2.9. 长度](#129-长度)
        - [1.2.10. 大小写转换](#1210-大小写转换)
        - [1.2.11. 单词首字母大写](#1211-单词首字母大写)
        - [1.2.12. 左补空格](#1212-左补空格)
        - [1.2.13. 右补空格](#1213-右补空格)
        - [1.2.14. 删除空格](#1214-删除空格)
        - [1.2.15. 重复字符串](#1215-重复字符串)
        - [1.2.16. 发音相似性比较](#1216-发音相似性比较)
    - [1.3. 日期函数](#13-日期函数)
        - [1.3.1. 系统时间](#131-系统时间)
        - [1.3.2. 前后几日](#132-前后几日)
        - [1.3.3. 求日期](#133-求日期)
        - [1.3.4. 求时间](#134-求时间)
        - [1.3.5. 取日期时间的其他部分](#135-取日期时间的其他部分)
        - [1.3.6. 当月最后一天](#136-当月最后一天)
        - [1.3.7. 本星期的某一天](#137-本星期的某一天)
        - [1.3.8. 字符串转时间](#138-字符串转时间)
        - [1.3.9. 求两日期某一部分的差](#139-求两日期某一部分的差)
        - [1.3.10. 根据差值求新的日期](#1310-根据差值求新的日期)
        - [1.3.11. 求不同时区时间](#1311-求不同时区时间)
- [2. Oracle和SQLServer函数简单对比](#2-oracle和sqlserver函数简单对比)
    - [2.1. 字符串函数](#21-字符串函数)
    - [2.2. 日期函数](#22-日期函数)
    - [2.3. 转换函数](#23-转换函数)
    - [2.4. 其它行级别的函数](#24-其它行级别的函数)
    - [2.5. 合计函数](#25-合计函数)
    - [2.6. 其它](#26-其它)
- [3. 存储过程](#3-存储过程)
    - [3.1. 多表连接查询](#31-多表连接查询)
    - [3.2. 更新数据](#32-更新数据)
    - [3.3. 删除数据](#33-删除数据)
- [其它](#其它)
    - [取前几条记录](#取前几条记录)
    - [游标](#游标)

<!-- /TOC -->

# 1. Oracle和SQLServer实例对比

## 1.1. 数学函数

### 1.1.1. 绝对值
```sql
S:  select abs(-1) value
O:  select abs(-1) value from dual;
```
### 1.1.2. 取整（大）
```sql
S:  select ceiling(-1.001) value
O:  select ceil(-1.001) value from dual
```

### 1.1.3. 取整（小）
```sql
S:  select floor(-1.001) value
O:  select floor(-1.001) value from dual
```
### 1.1.4. 取整（截取）
```sql
S:	select cast(-1.002 as int) value
O:	select trunc(-1.002) value from dual
```

### 1.1.5. 四舍五入
```sql
S:	select round(1.23456,4) value 1.23460
O:	select round(1.23456,4) value from dual 1.2346
```
### 1.1.6. e为底的幂
```sql
S:	select Exp(1) value 2.7182818284590451
O:	select Exp(1) value from dual 2.71828182
```

### 1.1.7. 取e为底的对数
```sql
S:	select log(2.7182818284590451) value
-- 1
O:	select ln(2.7182818284590451) value from dual;
-- 1
```

### 1.1.8. 取10为底对数
```sql
S:	select log10(10) value -- 1
O:	select log(10,10) value from dual; -- 1
```

### 1.1.9. 取平方
```sql
S:	select SQUARE(4) value -- 16
O:	select power(4,2) value from dual -- 16
```

### 1.1.10. 取平方根
```sql
S:	select SQRT(4) value -- 2
O:	select SQRT(4) value from dual; -- 2
```

### 1.1.11. 求任意数为底的幂
```sql
S:	select power(3,4) value -- 81
O:	select power(3,4) value from dual; -- 81
```

### 1.1.12. 取随机数
```sql
S:	select rand() value
O:	select sys.dbms_random.value(0,1) value from dual;
```

### 1.1.13. 取符号
```sql
S:	select sign(-8) value -- -1
O:	select sign(-8) value from dual; -- -1
```

### 1.1.14. 圆周率
```sql
S:	SELECT PI() value 3.1415926535897931
O:	不知道
```

### 1.1.15. 参数都以弧度为单位

```sql
--sin,cos,tan
select sin(PI()/2) value --得到1（SQLServer）
```

### 1.1.16. 返回弧度

`Asin,Acos,Atan,Atan2`

### 1.1.17. 弧度角度互换
```sql
--SQLServer
 DEGREES --弧度-〉角度
 RADIANS --角度-〉弧度

--Oracle不知道
```

### 1.1.18. 求集合最大值
```sql
S:
SELECT MAX(value) value
FROM   ( SELECT 1 value
         UNION
         SELECT -2 value
         UNION
         SELECT 4 value
         UNION
         SELECT 3 value ) a;
O:
SELECT
    greatest(1, - 2, 4, 3) value
FROM
dual;
```

### 1.1.19. 求集合最小值
```sql
S:
SELECT MIN(value) value
FROM   ( SELECT 1 value
         UNION
         SELECT -2 value
         UNION
         SELECT 4 value
         UNION
         SELECT 3 value ) a;
O:
SELECT
    least(1, - 2, 4, 3) value
FROM
    dual;
```

### 1.1.20. 如何处理null值
```sql
--F2中的null以10代替
S:	select F1, IsNull(F2,10) value from Tbl
O:	select F1, nvl(F2,10) value from Tbl
```
## 1.2. 字符串函数

### 1.2.1. 求字符序号
```sql
S: select ascii('a') value
O: select ascii('a') value from dual
```

### 1.2.2. 从序号求字符
```sql
S: select char(97) value
O: select chr(97) value from dual
```

### 1.2.3. 连接
```sql
S: select '11'+'22'+'33' value
O: select CONCAT('11','22') | | 33 value from dual
```
 
### 1.2.4. 子串位置
```sql
--返回3
S: select CHARINDEX('s','sdsq',2) value
O: select INSTR('sdsq','s',2) value from dual 　　
``` 
### 1.2.5. 模糊查找子串的位置
```sql
--返回2,参数去掉中间%则返回7
S: select patindex('%d%q%','sdsfasdqe') value
O: oracle没发现，但是instr
select INSTR('sdsfasdqe','sd',1,2) value from dual -- 返回6
```

### 1.2.6. 求子串
```sql
S: select substring('abcd',2,2) value
O: select substr('abcd',2,2) value from dual 　　
```

### 1.2.7. 子串代替
```sql
--返回aijklmnef
S: SELECT STUFF('abcdef', 2, 3, 'ijklmn') value
O: SELECT Replace('abcdef', 'bcd', 'ijklmn') value from dual
```

### 1.2.8. 子串全部替换
```sql 
S: 没发现
O: select Translate('fasdbfasegas','fa','我' ) value from dual
```

### 1.2.9. 长度

`S: len,datalength`

`O: length`

### 1.2.10. 大小写转换

`lower,upper`

### 1.2.11. 单词首字母大写
```sql
S: 没发现
O: select INITCAP('abcd dsaf df') value from dual
```

### 1.2.12. 左补空格
```sql
--LPAD的第一个参数为空格则同space函数
S: select space(10)+'abcd' value
O: select LPAD('abcd',14) value from dual 　　
```

### 1.2.13. 右补空格
```sql
--RPAD的第一个参数为空格则同space函数
S: select 'abcd'+space(10) value
O: select RPAD('abcd',14) value from dual
```

### 1.2.14. 删除空格

`S:ltrim,rtrim`

`O:ltrim,rtrim,trim`

### 1.2.15. 重复字符串
```sql
S: select REPLICATE('abcd',2) value
O: 没发现
```

### 1.2.16. 发音相似性比较
```sql
 --这两个单词返回值一样，发音相同
 S: SELECT SOUNDEX ('Smith'), SOUNDEX ('Smythe') 
 O: SELECT SOUNDEX ('Smith'), SOUNDEX ('Smythe') from dual;
 --SQLServer中用SELECT DIFFERENCE('Smithers', 'Smythers') 比较soundex的差 　　返回0-4，4为同音，1最高
```

## 1.3. 日期函数

### 1.3.1. 系统时间
```sql
S: select getdate() value
O: select sysdate value from dual;
```

### 1.3.2. 前后几日
 
`直接与整数相加减`
 
### 1.3.3. 求日期
```sql
S: select convert(char(10),getdate(),20) value
O: select trunc(sysdate) value from dual;
   select to_char(sysdate,'yyyy-mm-dd') value from dual;
```
### 1.3.4. 求时间
```sql
S: select convert(char(8),getdate(),108) value
O: select to_char(sysdate,'hh24:mm:ss') value from dual;
```

### 1.3.5. 取日期时间的其他部分
```sql
S: DATEPART 和 DATENAME 函数 （第一个参数决定）
O: to_char函数 第二个参数决定
```
参数,下表需要补充:

* year yy, yyyy
* quarter qq, q (季度)
* month mm, m (m O无效)
* dayofyear dy, y (O表星期)
* day dd, d (d O无效)
* week wk, ww (wk O无效)
* weekday dw (O不清楚)
* Hour hh,hh12,hh24 (hh12,hh24 S无效)
* minute mi, n (n O无效)
* second ss, s (s O无效)
* millisecond ms (O无效)
 
### 1.3.6. 当月最后一天
```sql
S: 不知道
O: select LAST_DAY(sysdate) value from dual 
```

### 1.3.7. 本星期的某一天
```sql
--比如星期日
S: 不知道
O: SELECT Next_day(sysdate,7) vaule FROM DUAL; 
```

### 1.3.8. 字符串转时间
```sql
S: 可以直接转或者 select cast('2004-09-08'as datetime) value
O: SELECT To_date('2004-01-05 22:09:38','yyyy-mm-dd hh24-mi-ss') vaule FROM DUAL;
```

### 1.3.9. 求两日期某一部分的差
```sql
--比如秒
S: select datediff(ss,getdate(),getdate()+12.3) value
O: 直接用两个日期相减（比如d1-d2=12.3）
   SELECT (d1-d2)*24*60*60 vaule FROM DUAL;
```

### 1.3.10. 根据差值求新的日期
```sql
--比如分钟
S: select dateadd(mi,8,getdate()) value
O: SELECT sysdate+8/60/24 vaule FROM DUAL;
```

### 1.3.11. 求不同时区时间
```sql
S: 不知道
O: SELECT New_time(sysdate,'ydt','gmt' ) vaule FROM DUAL;
```
时区参数,北京在东8区应该是Ydt：

* AST ADT 大西洋标准时间
* BST BDT 白令海标准时间
* CST CDT 中部标准时间
* EST EDT 东部标准时间
* GMT 格林尼治标准时间
* HST HDT 阿拉斯加—夏威夷标准时间
* MST MDT 山区标准时间
* NST 纽芬兰标准时间
* PST PDT 太平洋标准时间
* YST YDT YUKON标准时间 

# 2. Oracle和SQLServer函数简单对比

Oracle函数在前，N/A表示无类似函数

## 2.1. 字符串函数
 
* 把字符转换为ASCII ASCII
* 字串连接 CONCAT (expression + expression)
* 把ASCII转换为字符 CHR CHAR
* 返回字符串中的开始字符（左起） INSTR CHARINDEX
* 把字符转换为小写 LOWER LOWER
* 把字符转换为大写 UPPER UPPER
* 填充字符串的左边 LPAD N/A
* 清除开始的空白 LTRIM LTRIM
* 清除尾部的空白 RTRIM RTRIM
* 字符串中的起始模式（pattern） INSTR PATINDEX
* 多次重复字符串 RPAD REPLICATE
* 字符串的语音表示 SOUNDEX SOUNDEX
* 重复空格的字串 RPAD SPACE
* 从数字数据转换为字符数据 TO_CHAR STR
* 子串 SUBSTR SUBSTRING
* 替换字符 REPLACE STUFF
* 将字串中的每个词首字母大写 INITCAP N/A
* 翻译字符串 TRANSLATE N/A
* 字符串长度 LENGTH DATELENGTH or LEN
* 列表中最大的字符串 GREATEST N/A
* 列表中最小的字符串 LEAST N/A
* 如果为NULL则转换字串 NVL ISNULL

## 2.2. 日期函数

* 日期相加 (date column +/- value) or ADD_MONTHS DATEADD
* 两个日期的差 (date column +/- value) or MONTHS_BETWEEN DATEDIFF
* 当前日期和时间 SYSDATE GETDATE()
* 一个月的最后一天 LAST_DAY N/A
* 时区转换 NEW_TIME N/A
* 日期后的第一个周日 NEXT_DAY N/A
* 代表日期的字符串 TO_CHAR DATENAME
* 代表日期的整数 TO_NUMBER (TO_CHAR)) DATEPART
* 日期舍入 ROUND CONVERT
* 日期截断 TRUNC CONVERT
* 字符串转换为日期 TO_DATE CONVERT
* 如果为NULL则转换日期 NVL ISNULL

## 2.3. 转换函数

* 数字转换为字符 TO_CHAR CONVERT
* 字符转换为数字 TO_NUMBER CONVERT
* 日期转换为字符 TO_CHAR CONVERT
* 字符转换为日期 TO_DATE CONVERT
* 16进制转换为2进制 HEX_TO_RAW CONVERT
* 2进制转换为16进制 RAW_TO_HEX CONVERT

## 2.4. 其它行级别的函数
* 返回第一个非空表达式 DECODE COALESCE
* 当前序列值 CURRVAL N/A
* 下一个序列值 NEXTVAL N/A
* 如果exp1 = exp2, 返回null DECODE NULLIF
* 用户登录账号ID数字 UID SUSER_ID
* 用户登录名 USER SUSER_NAME
* 用户数据库ID数字 UID USER_ID
* 用户数据库名 USER USER_NAME
* 当前用户 CURRENT_USER CURRENT_USER
* 用户环境(audit trail) USERENV N/A
* 在CONNECT BY子句中的级别 LEVEL N/A

## 2.5. 合计函数
* Average AVG AVG Count
* COUNT COUNT
* Maximum MAX MAX
* Minimum MIN MIN
* Standard deviation STDDEV STDEV or STDEVP
* Summation SUM SUM
* Variance VARIANCE VAR or VARP

## 2.6. 其它

* Oracle还有一个有用的函数EXTRACT,提取并且返回日期时间或时间间隔表达式中特定的时间域: EXTRACT(YEAR FROM 日期)

# 3. 存储过程

## 3.1. 多表连接查询

SQLServer
```sql
ALTER PROCEDURE [dbo].[ GetEvent]
  @SCSWId NVARCHAR（20） = NULL, @ToDate DATETIME, @FromDate DATETIME
AS
  SELECT          NOTES.NOTE_ID, NOTES.NOTE, SCSW_CALENDAR.DATE_TIME
  FROM            SCSW_CALENDAR
  LEFT OUTER JOIN NOTES ON SCSW_CALENDAR.NOTE_ID = NOTES.note_id
  WHERE           SCSW_CALENDAR.SCSW_ID = SCSWId
  ORDER BY        Patient.PatientId;
```

Oracle
```sql
PROCEDURE getevent (
    scswid     IN    VARCHAR2,
    fromdate   IN    DATE,
    todate     IN    DATE,
    refout     OUT   refcursor
) IS
BEGIN
    OPEN refout FOR SELECT
                        notes.note_id,
                        notes.note,
                        scsw_calendar.date_time
                    FROM
                        scsw_calendar left
                        JOIN notes ON scsw_calendar.note_id = notes.note_id
                    WHERE
                        scsw_calendar.scsw_id = scswid
                        AND scsw_calendar.date_time >= fromdate
                        AND scsw_calendar.date_time < todate
                    ORDER BY
                        scsw_calendar.date_time;

END getevent;
```

## 3.2. 更新数据

Oracle
```sql
PROCEDURE updatearticlesubmodel (
    articlesubid        NUMBER,
    articletitle        NVARCHAR2,
    articlekeyword      NVARCHAR2,
    articlecontent      CLOB,
    createperson        NVARCHAR2,
    changedate          DATE,
    settop              NUMBER,
    articlesubstyleid   NUMBER,
    checked             NUMBER
) AS
BEGIN
    UPDATE "ArticleSubModel"
    SET
        "ArticleTitle" = articletitle,
        "ArticleKeyWord" = articlekeyword,
        "ArticleContent" = articlecontent,
        "CreatePerson" = createperson,
        "CreateDate" = changedate,
        "SetTop" = settop,
        "ArticleSubStyleID" = articlesubstyleid,
        "Checked" = checked
    WHERE
        "ArticleSubID" = articlesubid;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END updatearticlesubmodel;
```

## 3.3. 删除数据

Oracle
```sql
PROCEDURE deletearticlesubmodel (
    articlesubid NUMBER
) AS
BEGIN
    DELETE FROM "ArticleSubAccessories"
    WHERE
        "ArticleSubID" = articlesubid;

    DELETE FROM "ArticleSubModel"
    WHERE
        "ArticleSubID" = articlesubid;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END deletearticlesubmodel;
```

# 其它

## 取前几条记录

```sql
--s
select top 100 * from TableName

--o
select * from TableName where rownum<=10
```

## 游标

```sql
--s
--声明变量
DECLARE @DevId INT; --设备ID
DECLARE @DevName NVARCHAR(200);

--设备名称
--声明游标
DECLARE c_Dev CURSOR FOR SELECT DevId, DevName FROM dbo.Dev;

--打开游标，获取首行数据给变量
OPEN c_Dev;

FETCH NEXT FROM c_Dev
INTO @DevId, @DevName;

--从全局变量获取游标状态，0表示已到表尾
WHILE @@FETCH_STATUS = 0
BEGIN
  --处理过程
  SELECT @DevId, @DevName;

  FETCH NEXT FROM c_Dev
  INTO @DevId, @DevName;
END;

--关闭游标
CLOSE c_Dev;
--释放游标资源
DEALLOCATE c_Dev;

--o
DECLARE
  --定义游标
  CURSOR C_JOB IS
    SELECT DRUG_CODE, DRUG_NAME FROM DRUG_DICT WHERE ROWNUM <= 10;
  --定义游标变量
  C_ROW C_JOB%ROWTYPE;

BEGIN
  --循环游标
  FOR C_ROW IN C_JOB LOOP
    DBMS_OUTPUT.PUT_LINE(C_ROW.DRUG_CODE || '  ' || C_ROW.DRUG_NAME);
  END LOOP;
END;
```
