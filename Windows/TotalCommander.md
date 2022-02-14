# Total Commander使用技巧

## 使用Beyond Compare比较文件

编辑配置文件Wincmd.ini，在[Configuration]里添加下面配置：

```ini
[Configuration]
Comparetool=D:\DevTools\Beyond Compare\BCompare.exe
```

## 使用FastCopy

将FastCopy放到Total Commander的Tools目录下

新建usercmd.ini（如果没有），输入下面内容：

```ini
[em_fastcopy_cp]
button=
cmd=%COMMANDER_PATH%\Tools\FastCopy\FastCopy.exe
param=/no_exec /cmd=noexist_only /open_window /estimate /error_stop /bufsize=256 /log=FALSE /balloon=TRUE /skip_empty_dir /disk_mode=auto /speed=full /auto_close %P%S /to="%T"

[em_fastcopy_mv]
button=
cmd=%COMMANDER_PATH%\Tools\FastCopy\FastCopy.exe
param=/no_exec /cmd=move /open_window /estimate /error_stop /bufsize=256 /log=FALSE /balloon=TRUE /skip_empty_dir /disk_mode=auto /speed=full /auto_close %P%S /to="%T"
```

增加快捷键Ctrl+Alt+F5拷贝、Ctrl+Alt+F6移动，修改Wincmd.ini文件在[Shortcuts]节点添加下面内容：

```ini
CA+F5=em_fastcopy_cp
CA+F6=em_fastcopy_mv
```
