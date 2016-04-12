title: JavaScript基础入门
date: 2016-04-12 14:49:51
tags:
---


# 简介

+ 输出
`document.write("----")`
+ 回调
`<button type="button" onclick="func()">btn text</button>`
+ 改变内容
`document.getElementById("demo").innerHTML="str"`
+ 改变图像
`document.getElementById("demo").src="a.png"`


# Windows

## 函数
+ setTimeOut(func, time)
+ clearTimeOut()
+ setInterval()


# jquery

+ 基本语法
    $(selector).func()
+ 高级语法
    * `(function($){...})(jQuery); #定义匿名函数，并立即调用`
    * `jQuery.fn.xxx; #给jQuery 对象添加属性`
    * `jQuery.extend(); #给jQuery 类添加属性`

+ [选择器](http://www.w3school.com.cn/jquery/jquery_ref_selectors.asp)
    * 元素选择器
        - `$("p")        #选取所有p元素`
        - `$("p.class")  #选取所有指定class 的元素`
        - `$("p#id")     #选取所有指定id 的元素`
        - `$("ul li:first") #选取列表的第一个'li'元素`
    * 属性选择器
        - `$([herf])            #选取包含herf的元素`
        - `$([herf]='#')        #选取包含herf等于'#'的元素`
        - `$([herf]!="#")       #选取包含herf不等于'#'的元素`
        - `$([herf]$=".png")    #选取包含herf以'png'结尾的元素`
    * css 选择器
        - `$(p).css("back-ground-color", "red") #把所有 p 元素的背景颜色更改为红色`
+ [事件](http://www.w3school.com.cn/jquery/jquery_ref_events.asp)
    * `$(document).ready(function)     #将函数绑定到文档的就绪事件（当文档完成加载时）`
    * `$(selector).click(function)      #触发或将函数绑定到被选元素的点击事件`    
    * `$(selector).dblclick(function)   #触发或将函数绑定到被选元素的双击事件`    
    * `$(selector).focus(function)      #触发或将函数绑定到被选元素的获得焦点事件`    
    * `$(selector).mouseover(function)  #触发或将函数绑定到被选元素的鼠标悬停事件`
+ [动作效果](http://www.w3school.com.cn/jquery/jquery_ref_effects.asp)
+ [操作html属性](http://www.w3school.com.cn/jquery/jquery_ref_attributes.asp)
+ [操作htmlDOM操作](http://www.w3school.com.cn/jquery/jquery_ref_manipulation.asp)
+ [操作html css 属性](http://www.w3school.com.cn/jquery/jquery_ref_css.asp)
+ [ajax操作](http://www.w3school.com.cn/jquery/jquery_ref_ajax.asp)
+ [遍历DOM树](http://www.w3school.com.cn/jquery/jquery_ref_traversing.asp)
