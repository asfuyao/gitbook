@echo off

book sm -c ['Android','MacOS','Linux','Windows','开发工具','开发技术','Git','数据库','虚拟化','硬件']

set sed="C:\Program Files\Git\usr\bin\sed"
%sed% -i 2a\"- [说明](README.md)" SUMMARY.md