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
        _this = this
        data = @props.data
        if data.length
            data.map (item, i) ->
                item.goods_sku.map (sku, j) ->

                    price = sku.price
                    if sku.basic_price
                        save = SP.calc.Sub sku.basic_price, sku.price, 2
                    if save > 0
                        saveNode =
                            <span className="u-color-gray-summary">
                                （
                                <span className="u-del">￥{sku.basic_price}</span>{' '}省{save}
                                ）
                            </span>
                    else
                        saveNode = ""
                    if item.goods_type is 1
                        if sku.total_point
                            total_point = sku.total_point
                        else
                            point = SP.calc.Mul sku.price, 1
                            total_point = SP.calc.Mul point, sku.quantity
                        saveNode =
                            <span className="u-color-blackred">（消耗了{total_point}积分）</span>
                        price = '0.00'

                    if sku.earnest_money and sku.balance_due
                        status = item.presale_status
                        presalePriceNode =
                            <section className="u-mt-5">
                                <span className={if status is 0 then 'u-color-blackred' else ''}>
                                定金¥{sku.earnest_money}, </span>
                                <span className={if status is 1 then 'u-color-blackred' else ''}>
                                尾款¥{sku.balance_due}</span>
                            </section>
                    else
                        presalePriceNode = null


                    <div className="checkout-goods-item">
                        <div className="img">
                            <Img src={sku.cover} w={100} />
                        </div>
                        <div className="checkout-goods-content">
                            <h4 className="u-f14 u-mb-5 u-ellipsis">{item.title}</h4>
                            <section className="u-mb-10">
                                ￥{price}
                                {saveNode}
                                <span className="u-fr">X{sku.quantity}</span>
                            </section>
                            <section className="u-color-gray-summary u-ellipsis">
                                {sku.attribute}
                            </section>
                            {presalePriceNode}
                        </div>
                    </div>

        else
            ""

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
