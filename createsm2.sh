#!/bin/bash

echo "Create gitbook summary"

book sm -c ['MacOS','Linux','Windows','开发工具','开发技术','Git','数据库','虚拟化','硬件']

sed -i '2a\- [说明](README.md)' SUMMARY.md
