###
# CheckoutGoods. 商品清单, 可用于checkout和order
# @author remiel.
# @module CheckoutGoods
###
CheckoutGoods = React.createClass

    getInitialState: ->
        openGoodsView: no

    toggleopenGoodsView: () ->
        state = @state.openGoodsView
        @setState
            openGoodsView: !state

    renderGoods: () ->
        data = @props.data
        if data.length
            data.map (_item, i) =>
                if _item.is_multiple is yes
                    _item.items.map (item, i) =>
                        @renderItem item, _item.quantity
                else
                    item = _item.items
                    @renderItem item
        else
            ""

    renderItem: (item, collocation_quantity) ->
        type = @props.type
        price = item.price
        if item.basic_price
            save = SP.calc.Sub item.basic_price, price, 2
        if save > 0
            saveNode =
                <span className="u-color-gray-summary">
                    （
                    <span className="u-del">￥{item.basic_price}</span>{' '}省{save}
                    ）
                </span>
        else
            saveNode = ""
        # if item.goods_type is 1
        #     if sku.total_point
        #         total_point = sku.total_point
        #     else
        #         point = SP.calc.Mul sku.price, 1
        #         total_point = SP.calc.Mul point, sku.quantity
        #     saveNode =
        #         <span className="u-color-blackred">（消耗了{total_point}积分）</span>
        #     price = '0.00'

        # 积分兑换
        if type is 'exchange'
            if item.total_point
                total_point = item.total_point
            else
                point = SP.calc.Mul item.price, 1
                total_point = SP.calc.Mul point, item.quantity
            saveNode =
                <span className="u-color-blackred">（消耗了{total_point}积分）</span>
            price = '0.00'

        soldOut = <div className="cart-item-sold-out">已下架</div> if item.on_sale is 0

        quantity = item.quantity
        if collocation_quantity
            quantity = SP.calc.Mul collocation_quantity, quantity

        presalePriceNode = null
        if item.earnest_money and item.Balance_due
            presalePriceNode =
                <section className="u-pt-10">
                    <span className="u-color-blackred">{'定金¥' + item.earnest_money + ','}</span>
                    <span>{'尾款¥' + item.Balance_due}</span>
                </section>

        <div className="checkout-goods-item" key={item.id}>
            <div className="img">
                <Img src={item.image} w={100} />
                {soldOut}
            </div>
            <div className="checkout-goods-content">
                <h4 className="u-f14 u-mb-5 u-ellipsis">{item.title}</h4>
                <section className="u-mb-10">
                    ￥{price}
                    {saveNode}
                    <span className="u-fr">X{quantity}</span>
                </section>
                <section className="u-color-gray-summary u-ellipsis">
                    {item.sub_title}
                </section>
                {presalePriceNode}
            </div>
        </div>



    renderFooter: () ->
        goods = @renderGoods()
        if goods.length and (goods.length > 1 or goods[0].length > 1)
            <Tappable component="footer" className={'active' if @state.openGoodsView} onTap={@toggleopenGoodsView}>
                <Button bsStyle="icon" icon="arrowdownlarge" />
            </Tappable>
        else
            ""

    render: ->
        data = @props.data
        classes = SP.classSet "form-box checkout-goods", @props.className
        <div className={classes}>
            {@props.children}
            <div className="form-box-bd">
                <div className={'active' if @state.openGoodsView}>
                    {@renderGoods()}
                </div>
                {@renderFooter()}
            </div>
        </div>


module.exports = CheckoutGoods
