###
# Goods.
# @author remiel.
# @module Goods
###
CheckoutGoods = require './checkout-goods'
Goods = React.createClass
    render: ->
        data = @props.data
        type = ''
        type = 'exchange' if data.exchange is 1
        items = data.items.items

        if data.presale is 1
            items = data.items.items.map (item) ->
                item.items.earnest_money = data.presale_batch_skus.earnest_money
                item.items.Balance_due = SP.calc.Sub data.price.total, data.presale_batch_skus.earnest_money
                item

        <CheckoutGoods className="u-mb-10" data={items} type={type}>
            <header className="form-box-hd has-border-bottom no-margin-sides has-padding-sides">
                商品清单
            </header>
        </CheckoutGoods>


module.exports = Goods
