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
v-for="todo in todos"
v-bind
v-on
v-model
v-once
v-html

# 绑定Class
## 对象语法
```js
<a v-bind:class="active"> </a>
//等价于
//active class 是否存在取决于 isActive 属性
<a v-bind:class="{active: isActive}"> </a>
//等价于
<a v-bind:class="classObj"> </a>
data：{
    classObj:{
        active : true,
    }
}
```
## 数组语法
```js
data:{activeClass:'active'}
<a v-bind:class="[activeClass]"> </a>

<a v-bind:class="[{active: isActive}]"> </a>
<a v-bind:class="[isActive ? activeClass : '']"> </a>
```
## 用在组件上
在一个自定义组件上使用 class 时，它们会被添加到该组件的根元素上面，已经存在的类不会被覆盖。

# 绑定 Style
```js
data:{
    styleObject:{
        color: 'red',
        fontSize: '13px'
    }
}
<div v-bind:style="styleObject"> </div>
//也可以直接将对象写在模板中
```
## 也可以使用数组语法， 将多个样式对象应用到同一元素上
## 其他
当使用需要添加浏览器引擎前缀的 CSS 属性是， Vue 会自动检测并添加。

# 条件渲染
v-if
v-else
v-else-if
## 使用 template 控制多个元素
template 并不会出现在最终的渲染结果中。
```html
<template v-if="ok">
  <h1>Title</h1>
  <p>Paragraph 1</p>
</template>
```
## 元素复用
当你在 if else 之间来回切换的时候，如果有相同的元素， Vue 会复用它们.
如果你不想它们被复用，可以使用 key 属性来标识它们。
```html
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username" key="username-input">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address" key="email-input">
</template>
```
上例中 `<label>` 元素会被复用， 但是 `<input>` 不会， 因为它们有各自不同的key.

## v-show
v-show 也可以根据条件来控制元素的展示。 不同的是 v-show 会始终存在于 DOM 中， 只不过切换了 `display` 属性。

# 列表渲染
v-for
+ v-for 有对父作用域的完全访问。
+ 可以遍历数组或对象
## 遍历数组
+ 可以有第二个可选的参数为当前项的索引
## 遍历对象
+ 可以有第二个可选的参数为当前项的键
+ 可以有第三个可选的参数为当前项的索引
+ 按 Object.keys() 的结果遍历， 不保证在不同的 JS 引擎中有相同的便利顺序
## key 属性
+ 更新时， 默认使用 "就地复用" 策略，即按索引复用
+ 可以给子节点绑定一个 key 属性， 以便 vue 能根据 key 快速的复用之前的子节点。
## 数组操作
vue 能检测到大部分对数组的方法操作。但是有两种情况检测不到。
1. 当你直接利用索引设置新项时
vm.items[index] = newValue
可以使用下面几种方式来触发状态更新。
+ Vue.set(vm.items, index, newValue)
+ vm.items.splice(index, 1, newValue)
+ vm.$set(vm.items, index, newValue)
2. 当你直接修改数组长度时
vm.length = newLength
使用下面方法触发更新。
+ vm.items.splice(newLength)
## 对象操作
vue 不能检测到对象属性的添加或删除。
可以使用 `Vue.set` 来触发属性更新
## 可以与 计算属性或 method 结合使用
## 范围取值
```html
<span v-for="n in 10">{{n}}</span>
```
## 与 v-if 
v-for 优先级更高， 会遍历 v-for 的所有属性， 然后对每个属性执行 v-if

# 事件处理
v-on
+ 直接在事件监听中触发 js 代码
+ 指向一个方法名称
+ 监听中调用方法
+ 监听中使用特殊变量 $event 将事件传入处理方法
## 事件修饰符
事件修饰符可以串联使用， 串联顺序很重要
+ .stop
+ .prevent
+ .capture
+ .self
+ .once
+ .passive
## 按键修饰符
`v.on:keyup.enter="submit"` 监听了 enter 键被按下释放
`v.on:keyup.ctrl.enter="submit"` 监听了 ctrl + enter 键被按下释放
### .exact 
有且只有定义的按键被按下时才会触发.
### 自定义按键修饰符别名
Vue.config.keyCodes.f1 = 112

# 表单输入绑定
v-model 可以在表单元素上创建双向数据绑定

# 组件
+ 组件没有 el 选项
+ 组件的 data 必须是一个函数，这样每个实例都会有独立的数据域
## 属性 props
## 向父级组件发送消息
`$emit(eventName, data)` 可以向父组件发送消息
父组件可以使用 `v-on:eventName=func` 处理消息
