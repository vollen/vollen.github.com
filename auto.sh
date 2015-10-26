#!/bin/bash
# 生成
hexo g
# 发布
hexo d

#同步git
git add .
#提交本地
git commit -m "update"
#推送到远程
git push
