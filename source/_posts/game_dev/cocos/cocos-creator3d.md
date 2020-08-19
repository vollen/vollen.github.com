

# 问题解决
## dock 中图标特别小
可以用以下命令行还原
`defaults write com.apple.dock contents-immutable -bool false;killall Dock`
