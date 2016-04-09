title: sublime-text配置
date: 2015-07-20 11:36:54
tags: sublime
---

sublime是一个超级好用的编辑器, 可以根据个人喜好来配置,因此要找到一个自己用起来顺手的配置,也是不太容易, 下面我的sublime配置：
<!--more-->


```json
    {
        // 设置SourceCodePro等宽字体，以便阅读
        "font_face": "SourceCodePro",
        "font_size": 10.0,
        // 使光标闪动更加柔和
        "caret_style": "phase",
        // 高亮当前行
        "highlight_line": true,
        // 高亮有修改的标签
        "highlight_modified_tabs": true,

        // 设置tab的大小为4
        "tab_size": 4,
        // 使用空格代替tab
        "translate_tabs_to_spaces": true,
        // 添加行宽标尺
        "rulers": [80, 160],
        // 保存时自动去除行末空白
        "trim_trailing_white_space_on_save": true,
        // 保存时自动增加文件末尾换行
        "ensure_newline_at_eof_on_save": true,

        "ignored_packages":
        [
            "Vintage",
            "Markdown"
        ],
    }
```


#perl 快速调试
Tools->Build System->New Build System.输入以下内容:
```
{
"cmd": ["perl", "-w", "$file"],
"file_regex": ".* at (.*) line ([0-9]*)",
"selector": "source.perl"
}
```

保存为文件名Perl.sublime-build

# SourceCodePro 字体下载
[链接](https://github.com/adobe-fonts/source-code-pro)
