###
# Note.
# @author remiel.
# @module Checkout
###

Store = appStores.checkout
Action = Store.getAction()
Note = React.createClass
    mixins: [liteFlux.mixins.storeMixin('checkout')]

    onChange: (e) ->
        el = e.target
        value = el.value
        Action.onChange value, 'note'
    render: ->
        <div className="form-box u-mb-10 checkout-note">
            <header className="form-box-hd large-padding">
                <Textarea placeholder="添加订单备注" autoResize={yes} value={@state.checkout.note} onChange={@onChange} />
            </header>
        </div>

module.exports = Note
