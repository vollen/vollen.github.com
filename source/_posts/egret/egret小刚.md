title: egret小刚
tags:
    - 
---

exml
RES
Event
引入第三方库

ts 将string转成number [](http://stackoverflow.com/questions/14667713/typescript-converting-a-string-to-a-number)

## egret 引入字体文件
1. 声明font-face
2. 在html页面中使用
3. 监听字体加载完成事件
4. 删除页面中使用字体的结点
5. 进入游戏
6. 在游戏中设置字体为刚刚声明的字体
```js
    @font-face {
        font-family:"HANYI";
        src: url("./resource/HY.ttf");
    }
    <p id="font_loader" style="font-family:HANYI">
        随便什么文字
    </p>
    document.fonts.ready.then(function(){
        var ele = document.getElementById("font_loader");
        if(ele){
            ele.parentNode.removeChild(ele);
        }
        enterGame();
    })
    function newText(){
        var text = new egret.TextField();
        text.fontFamily = "HANYI"
    }
```
