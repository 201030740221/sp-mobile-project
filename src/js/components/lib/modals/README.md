# modals

- modal: 一般的modal, 内容自定义
- comfirm-modal: 带确认取消按钮的modal (未实现)
- alert-modal: 只带确认按钮的modal (未实现)
- message: 消息提示,出现x秒后自动消失 (未实现)

## Modal
`lite-modal`: `Modal type="lite-modal"`(`type`默认值为`lite-modal`, 可不填)

```js
<Modal name="cart-delete" onCloseClick={@onModalHide} showClose={true} show={@state.showModal}>
    <div className="u-text-center u-pb-20 u-pt-30 u-f16">确认删除选中商品?</div>
    <div className="u-text-center u-pb-20">
        <Button className="u-mr-20" onTap={@onDelete}>删除</Button>
        <Button onTap={@onModalHide}>取消</Button>
    </div>
</Modal>
```

弱提示框`message`: `Modal`的扩展 ` type=“message"`

```
<Modal name="cart-delete" onCloseClick={@onHide} show={@state.show} type=“message" >
    红红火火恍恍惚惚哈哈哈哈哈~~~
</Modal>
```

## SP.message

SP调用弱提示框`SP.message(opts)`

```js

SP.message({
    msg: `string` or React Element `<xxx />`
    type: string //`error`等(未实现)
    duration: number
    callback: function
})

```
