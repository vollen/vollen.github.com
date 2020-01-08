
# 浏览器跨域问题
除了需要设置 `Access-Control-Allow-Origin`外, 还需要设置
`Access-Control-Allow-Headers` 添加上可允许的`header`字段。
[Access-Control-Allow-Headers](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Access-Control-Allow-Headers)
```js
res.header("Access-Control-Allow-Origin", "*");
res.header("Access-Control-Allow-Headers", "Content-Type,access-control-allow-origin,X-Requested-With");
res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
```

## 错误提示
>> Response to preflight request doesn't pass access control check: No 'Access-Control-Allow-Origin' header is present on the requested resource
没有 `Access-Control-Allow-Origin` 头，需要在返回头中添加上`Access-Control-Allow-Origin`字段，包含对应的域名

>> Request header field access-control-allow-origin is not allowed by Access-Control-Allow-Headers in preflight response.
`access-control-allow-origin` 请求头不被允许, 需要添加 `Access-Control-Allow-Headers` 头, 声明需要的`header` 字段。
