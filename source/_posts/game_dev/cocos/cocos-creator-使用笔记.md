图片资源类型为 Raw, 不会被打包到图集中


# 插件开发
## IPC 基础
[ipc工作流程](http://docs.cocos.com/creator/manual/zh/extension/ipc-workflow.html)
## 常用 IPC
```js
//创建一个空节点：
Editor.Ipc.sendToPanel('scene', 'scene:create-node-by-classid', 'New Node', '', 'parentUuid');
//添加一个组件：
Editor.Ipc.sendToPanel('scene', 'scene:add-component', nodeID, 'cc.Animation');
//删除一个组件：
Editor.Ipc.sendToPanel('scene', 'scene:remove-component', nodeID, compID);
//复制节点
Editor.Ipc.sendToPanel('scene', 'scene:copy-nodes', uuids);
//粘贴节点:
Editor.Ipc.sendToPanel('scene', 'scene:paste-nodes', parentID);
//生成prefab
Editor.Ipc.sendToPanel('scene', 'scene:create-prefab', node.uuid, 'db://assets/xxx/xxx.prefab');
//设置结点属性
Editor.Ipc.sendToPanel('scene', 'scene:set-property', {
    id: this.node.id,
    path: 'name',
    type: 'String',
    value: event.target.value,
    isSubProp: false,
});
//保存
Editor.Ipc.sendToPanel('scene', 'scene:undo-commit');
//保存当前场景
Editor.Ipc.sendToPanel('scene', 'scene:stash-and-save');
//查询场景中的某个结点
Editor.Ipc.sendToPanel('scene', 'scene:query-node', uuid, (error, dump) => {});
//保存prefab
Editor.Ipc.sendToPanel( 'scene', 'scene:apply-prefab', node.uuid);
```

## Selection
type 可选类型包括: `node`, `asset`, 
```js
Editor.Selection.curSelection(type);// 获取的是多选的节点
Editor.Selection.curActivate(type);// 获取的是当前激活的节点
```

## 可监听的 IPC 消息
```js
selection:activated(event, type, id); //选中
selection:deactivated //取消选中
```

Editor.remote.currentSceneUuid


## _Scene 控制场景编辑器里加载的场景实例
_Scene.loadSceneByUuid()

## 场景脚本
[调用引擎 API 和项目脚本](https://docs.cocos.com/creator/manual/zh/extension/scene-script.html)
可以调用引擎和自定义组件的方法，通过 `ipc 消息`发起调用
```js
//从扩展包中向场景脚本发送消息
Editor.Scene.callSceneScript('comp', 'msg', callback);
```

# 小技巧
## 动态合图
在引擎初始化前，使用下面语句可关闭动态合图
```js
// cc.macro.CLEANUP_IMAGE_CACHE = true;
```

