# 批量删除过期文件

```shell
#!/bin/bash

path_base="/srv/dev-disk-by-uuid-c76720b6-0811-4e78-a849-1c4d6e9fedf3/SqlServerBackup/IP"
expire_day=90

array_path=("32" "34" "35" "36" "234" "235" "238")

for item in ${array_path[*]}
do
  for bakfile in `find $path_base$item/ -mtime +$expire_day -type f -name "*.bak"`
  do
    rm -f $bakfile
  done
done
```

