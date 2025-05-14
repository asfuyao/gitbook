# git知识整理

## 创建和推送分支

```shell
git checkout -b <your-new-branch-name> #创建并切换到新分支
git switch -c <your-new-branch-name> #创建并切换到新分支，Git版本2.23.0或更高
git push -u origin <your-new-branch-name> #推送本地分支到远程仓库，-u参数（或者--set-upstream）的作用是建立本地分支与远程分支的关联，这样以后只需运行git push就可以推送更新到对应的远程分支，而不需要每次都指定远程和分支名
```

## 删除分支

```shell
git push origin --delete branch-name #删除远程分支
```



## merge分支

```shell
git checkout <other-branch> #迁出要融合的分支
git pull #更新代码
git checkout <current-branch> #切换为当前分支
git merge master #正常融合，手动解决冲突
git merge -X ours <other-branch> #融合时有冲突的文件保留 <current-branch> 分支的代码
git merge -X theirs <other-branch> #融合时有冲突的文件保留 <other-branch> 分支的代码
```

## 不切换分支merge分支

```shell
git fetch origin origin/<other-branch> #拉取远程分支的最新代码
git merge origin/<other-branch> #将远程分支的代码合并到当前分支

git merge --no-commit origin/<other-branch> #合并远程分支的代码，但不自动提交，以手动检查更改后，再提交

git log origin/<other-branch> #查看提交日志
git cherry-pick <commit-hash> #将特定提交应用到当前分支
```

## 分支冲突解决

```shell
git checkout <other-branch> #迁出要融合的分支
git pull #更新代码
git checkout <current-branch> #切换为当前分支
git merge master #正常融合，手动解决冲突

git status #查看冲突文件

#使用 <other-branch> 分支的版本
git checkout --theirs file1.txt
git add file1.txt

#使用当前分支 <current-branch> 的版本
git checkout --ours file2.txt
git add file2.txt

git checkout --ours file3.txt
git add file3.txt

#继续合并操作
git merge --continue
```

