# 设置环境变量

在path中添加你所安裝的 postgresql 路徑下的bin和lib，例如：C:\pgsql\bin; C:\pgsql\lib

# 安装timescaledb

* 关闭 postgresql 服务
* 解压缩后运行setup.exe，需要管理员权限安装
* 安装过程需要输入 postgresql 配置文件地址，例如：C:\pgsql\data\postgresql.conf
* 其他选择yes即可
* 安装完毕启动 postgresql 服务

# 检查是否安装成功

执行语句：

```sql
# 创建一个新的数据库
createdb mydatabase

# 连接到该数据库
psql mydatabase

# 在数据库中加载TimescaleDB扩展
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
```

# 时序数据库功能的使用

**1. 创建表并插入数据**

TimescaleDB中的基本数据管理单元称为超级表。超级表是基于普通表的一种特殊类型，它将时间序列数据根据时间进行分区和组织，从而实现更高效的查询性能。以下示例演示了如何创建一个超级表：

```sql
-- 创建超级表
CREATE TABLE conditions (
    time        TIMESTAMPTZ       NOT NULL,
    location    TEXT              NOT NULL,
    temperature DOUBLE PRECISION  NULL,
    humidity    DOUBLE PRECISION  NULL
);

-- 对超级表进行分区
SELECT create_hypertable('conditions', 'time');
--按 1 小时一个 chunk 分区
SELECT create_hypertable('conditions', 'time', chunk_time_interval => INTERVAL '1 hour');

--开启列式压缩（节省 90%+ 空间）
ALTER TABLE conditions SET (timescaledb.compress, timescaledb.compress_segmentby = 'location');
--自动把 24 h 前的数据压缩
SELECT add_compression_policy('conditions', INTERVAL '24 h');
--自动清理，超90天的chunk会被自动drop，空间立即回收。
SELECT add_retention_policy('conditions', INTERVAL '90 days');

-- 插入数据
INSERT INTO conditions (time, location, temperature, humidity)
VALUES
   ('2023-06-29 06:00:00', 'New York', 25.4, 60.2),
   ('2023-06-29 07:00:00', 'New York', 26.8, 58.9),
   ('2023-06-29 08:00:00', 'New York', 28.3, 57.1);
```

创建Hypertable：TimescaleDB中的核心概念是Hypertable，它是一个逻辑表，负责将普通表划分成不同的时间段。其中，'table_name'是原始表的名称，'time_column'是存储时间信息的列。

**2. 查询最新的N条数据**

假设我们想要查询最新的3条温度数据。以下示例演示了如何使用`LIMIT`子句和`ORDER BY`子句进行查询：

```sql
SELECT *
FROM conditions
ORDER BY time DESC
LIMIT 3;
```

**3. 执行时间范围内的聚合查询**

假设我们想要计算过去一小时内每分钟的平均温度。以下示例展示了如何使用时间序列聚合函数和时间戳桶函数进行查询：

```sql
SELECT time_bucket('1 minute', time) AS minute,
      AVG(temperature) AS average_temperature
FROM conditions
WHERE time > NOW() - INTERVAL '1 hour'
GROUP BY minute;
```