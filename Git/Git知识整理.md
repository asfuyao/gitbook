# git知识整理

## merge分支

本例中需要融合master分支内容到feature分支

```shell
git checkout master #迁出要融合的分支
git pull #更新代码
git checkout feature
git merge master #正常融合，手动解决冲突
git merge -X ours master #融合时有冲突的文件保留 feature 分支的代码
git merge -X theirs master #融合时有冲突的文件保留 master 分支的代码
```

## 分支冲突解决

本例中需要融合master分支内容到feature分支

```shell
git checkout master #迁出要融合的分支
git pull #更新代码
git checkout feature
git merge master #正常融合，手动解决冲突

git status #查看冲突文件

#使用 master 分支的版本
git checkout --theirs file1.txt
git add file1.txt

#使用当前分支的版本
git checkout --ours file2.txt
git add file2.txt

git checkout --ours file3.txt
git add file3.txt

#继续合并操作
git merge --continue
```

