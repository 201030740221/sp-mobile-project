Store = appStores.activityNovember4
Action = Store.getAction()
storeName = 'activity-november-4'

PageView = React.createClass

    mixins: [liteFlux.mixins.storeMixin(storeName)]

    colorMap: [
        'cyan'
        'orchid'
        'orange'
        'green'
        'purple'
    ]
    addToCart: (item) ->
        data =
            "id": item.id
            "items": {}
        item.goods.map (item, i) =>
            data["items"][item.id] = 1
        data = JSON.stringify data
        Action.addToCart data


    renderList: () ->
        store = @state[storeName]
        if store.collocations and store.collocations.length
            node = store.collocations.map (item, i) =>
                color = @colorMap[i%5]
                price = '0.00'
                if item.goods and item.goods.length > 1
                    price = (SP.calc.Add item.goods[0].price, item.goods[1].price).toFixed 0


                <div className="activity-november-4-block-2-item" key={i}>
                    <div className="activity-november-4-info bg-#{color}" key={i}>
                        <div className="u-color-white">{item.name}</div>
                        <div className="u-color-yellow">
                            <span className="u-inline-block">轻推荐指数：</span>
                            <i className="activity-november-4-star"></i>
                            <i className="activity-november-4-star"></i>
                            <i className="activity-november-4-star"></i>
                            <i className="activity-november-4-star"></i>
                            <i className="activity-november-4-star"></i>
                        </div>
                        <Tappable component="div" className="activity-november-4-price u-text-center" onTap={@addToCart.bind(null, item)}>
                            <div>最佳搭配价</div>
                            <div>
                                <span className="u-f12">￥</span>
                                <span className="u-f18">{price}</span>
                            </div>
                            <div>点击购买</div>
                        </Tappable>
                    </div>
                    <div className="activity-november-4-block-2-goods u-clearfix">
                        <i className="activity-november-4-block-2-goods-icon-plus bg-#{color}"></i>
                        {@renderGoods(item.goods, color)}
                    </div>
                </div>
            <SliderHorizontal nav nav-center nav-square2>
                {node}
            </SliderHorizontal>

    renderGoods: (goods, color) ->
        if goods and goods.length
            goods.map (item, i) =>
                if i< 2
                    <Tappable component="div" className="activity-november-4-block-2-goods-item" onTap={@goToSku.bind(null, item)} key={i}>
                        <Img src={item.has_cover.media.full_path} w={320} />
                        <div className="activity-november-4-block-2-goods-item-title u-f14 u-mt-15 u-text-center">{item.goods and item.goods.title}</div>
                        <div className="u-mt-10 u-text-center">
                            <Tappable className="activity-november-4-btn btn-#{color}">抄底价：￥{item.price}</Tappable>
                        </div>
                    </Tappable>

    goToSku: (item) ->
        SP.redirect "/item/" + item.sku_sn

    renderList1: () ->
        store = @state[storeName]
        if store.fixedPriceSkus and store.fixedPriceSkus.length
            store.fixedPriceSkus.map (item, i) =>
            # [1,2,3,4].map (item, i) =>
                <div className="activity-november-4-block-3-item" key={i}>
                    <Tappable component="div" className="activity-november-4-block-3-item-inner" onTap={@goToSku.bind(null, item)}>
                        <Img src={item.has_cover.media.full_path} w={320}/>
                        <div className="u-f16 u-mt-10 u-text-center">{item.goods and item.goods.title}</div>
                        <div className="u-mt-10 u-text-center">
                            <Tappable className="activity-november-4-btn btn-orange-yellow">原价：￥{item.price}</Tappable>
                        </div>
                    </Tappable>
                </div>


    render: ->

        <div className="activity-november-4-block-2">
            <div className="activity-november-4-title single-row">
                <div className="activity-november-4-title-text">疯狂抄底价，返场大钜惠</div>
            </div>
            {@renderList()}
        </div>

module.exports = PageView
