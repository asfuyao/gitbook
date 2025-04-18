# 创建用户Token

Token创建方式：

* 点击右上角用户名进入用户视图
* Security->添加新的Token

# 导出配置

```shell
java -jar jenkins-cli.jar -s http://jenkins服务IP:端口号 -auth 用户名:Token get-job 任务名 > 导出文件名.xml
```

# 导入配置

```shell
java -jar jenkins-cli.jar -s http://jenkins服务IP:端口号 -auth 用户名:Token create-job 任务名 < 任务文件名.xml
```



