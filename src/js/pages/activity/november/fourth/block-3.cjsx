Store = appStores.activityNovember4
Action = Store.getAction()
storeName = 'activity-november-4'
PageView = React.createClass

    mixins: [liteFlux.mixins.storeMixin(storeName)]
    goToSku: (item) ->
        SP.redirect "/item/" + item.sku_sn

    renderList: () ->
        store = @state[storeName]
        if store.fixedPriceSkus and store.fixedPriceSkus.length
            store.fixedPriceSkus.map (item, i) =>
            # [1,2,3,4].map (item, i) =>
                <div className="activity-november-4-block-3-item" key={i}>
                    <Tappable component="div" className="activity-november-4-block-3-item-inner" onTap={@goToSku.bind(null, item)}>
                        <Img src={item.has_cover.media.full_path} w={320}/>
                        <div className="u-f14 u-mt-15 u-text-center">{item.goods and item.goods.title}</div>
                        <div className="u-mt-10 u-text-center">
                            <Tappable className="activity-november-4-btn btn-orange-yellow">原价：￥{item.price}</Tappable>
                        </div>
                    </Tappable>
                </div>


    render: ->

        <div className="activity-november-4-block-3">
            <div className="activity-november-4-title">
                <div className="activity-november-4-title-text">
                    <span>优惠大抄底</span>
                    <br />
                    <span>温暖满￥999就送!</span>
                </div>
            </div>
            <div className="activity-november-4-info bg-blue u-text-center">
                <div className="u-color-white">返场活动购满￥999，即可随机赠送以下热卖商品一件。</div>
                <div className="u-color-white">数量有限，先到先得！赶紧来抢吧~~~</div>
            </div>
            <div className="u-clearfix">
                {@renderList()}
            </div>
        </div>

module.exports = PageView
