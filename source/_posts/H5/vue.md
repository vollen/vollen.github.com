# Vue
+ el
绑定到的结点
+ methods
成员函数
+ data
成员属性
+ computed
计算属性
基于他们的依赖进行，只有当依赖属性发生变化时，计算属性才会重新求值。
当不需要缓存时，可以使用 `method` 组合 `双大括号法` 来替代。
直接给计算属性一个方法时，它默认是该属性的 `getter` 方法。
也可以给计算属性设置 `setter` 方法，
```js
computed:{
    attr:{
        get : function(){ return val;},
        set : function(val){},
    }
}
```
+ watch
侦听属性，watch 的属性为 data 中声明的属性， 当属性值变化的时候，会调用 watch 的方法。
## 内置属性方法
$data
$el
$watch
## 生命周期
[生命周期图](https://cn.vuejs.org/images/lifecycle.png)
beforeCreate
created
beforeMount
mounted
beforeUpdate
updated
beforeDestory
destoryed
## Vue.component
声明自定义组件
props
template
# 模板语法
## 数据绑定
+ “Mustache”语法(双大括号)
{{data}}
不能作用在 HTML特性中， 这时应该使用 v-bind 指令。
+ v-html
将属性输出为真正的html
只应该对信任内容使用该指令，绝不要对用户提供的内容使用插值，否则可能会导致xss 攻击。
+ 数据绑定支持完全的 JavaScript 表达式。
会在所属 Vue 实例的数据作用于下被解析
只能支持表达式，语句或流控制都不会生效
除了 Math 和 Date， 不能访问任何别的全局变量。
## 指令
### 参数
部分指令能接收一个“参数”，在指令后以冒号(:)表示。
例如： `v-on:click="funcName"`
### 修饰符
修饰回复是以半角句号`.` 知名的特殊后缀， 用于指出一个指令应该以特殊方式绑定。
+ `.prevent` 告诉 `v-on` 指令对于触发的事件调用 `event.preventDefault()`
### 缩写
+ v-bind 使用 :
`<a v-bind:href="url"></a>`
等价于
`<a :href="url"></a>`
+ v-on 使用 @
`<a v-on:click="doSome"></a>`
等价于
`<a @click="doSom"></a>`
### 常用指令
v-if
v-for="todo in todos"
v-bind
v-on
v-model
v-once
v-html

## 虚拟dom