@echo off

book sm -c ['开发工具','开发技术','其它','数据库','虚拟化','硬件','Android','Git','Linux','MacOS','Windows']

set sed="C:\Program Files\Git\usr\bin\sed"
%sed% -i 2a\"- [说明](README.md)" SUMMARY.md