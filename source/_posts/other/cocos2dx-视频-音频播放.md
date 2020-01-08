title: cocos2dx_视频/音频播放
tags: 
    - cocos2dx
    - media
    - audio
---

[android MediaPlayer 分析使用](http://www.devdiv.com/Android-MediaPlayer%E7%9A%84%E4%BD%BF%E7%94%A8-thread-130166-1-1.html)
[MediaPlayer 官方文档](http://developer.android.com/reference/android/media/MediaPlayer.html)

# 待分析完善

# WebView
``` c++
// add webview
auto webview = cocos2d::experimental::ui::WebView::create();
Size *_size = new Size(visibleSize.width-100, visibleSize.height-100);
webview->setContentSize(*_size);
webview->setPosition(Vec2(origin.x + visibleSize.width/2, origin.y + visibleSize.height/2));
webview->setScalesPageToFit(true);
webview->setBounces(false);
webview->loadURL("https://www.baidu.com/");

webview->setOnShouldStartLoading([](cocos2d::experimental::ui::WebView *sender, const std::string &url){
    return true;
});

webview->setOnDidFinishLoading([](cocos2d::experimental::ui::WebView *sender, const std::string &url){
});


webview->setOnDidFailLoading([](cocos2d::experimental::ui::WebView *sender, const std::string &url){
});

this->addChild(webview);
```
# openUrl
```c++
cc.Application:getInstance():openUrl("https://www.baidu.com")
```