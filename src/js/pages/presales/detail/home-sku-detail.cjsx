React = require 'react'
moment = require 'moment'
storeName = 'presales-detail'
Store = require 'stores/presales-detail'
Action = Store.getAction()
IconYiYuan = require './icon-yi-yuan'
View = React.createClass
    skuStoreName: storeName
    mixins: [liteFlux.mixins.storeMixin(storeName)]

    render: ->

        store = @state[storeName]
        current = store.current
        if current is null
            return ''
        server_time = store.server_time
        skuPicker = store.skuPicker
        sku = skuPicker.selected_sku
        hasCurrentBatches = no
        presale_price = ''
        earnest_money = ''
        price_name = '预售价'

        oneYuan = ''
        time = ''

        if current.batches and current.batches.length
            current.batches.map (batches, j) =>
                # 找到当前批次
                if batches.id is current.next_valid_batch_id
                    hasCurrentBatches = yes
                    batches.skus.map (item, i) =>
                        if +sku.id is item.goods_sku_id
                            presale_price = item.presale_price
                            earnest_money = item.earnest_money


                    # 开售前
                    if moment(server_time).isBefore(batches.begin_at)
                        console.log '开售前'
                        time =
                            <div>
                                <span className="u-color-gray-summary">首发预订时间：</span>
                                <span>{current.begin_at}</span>
                            </div>
                        presale_price = current.presale_price_tip
                        earnest_money = current.earnest_money_tip
                    # 开售ing
                    else if moment(server_time).isBefore(batches.end_at)
                        time =
                            <div>
                                <span className="u-color-gray-summary">(注：尾款需在{current.batches[0].pay_deadline}内进行支付)</span>
                                <span></span>
                            </div>
            if not hasCurrentBatches
                current.batches[current.batches.length - 1].skus.map (item, i) =>
                    if +sku.id is item.goods_sku_id
                        presale_price = item.presale_price
                        earnest_money = item.earnest_money

            # 第一批开售前
            if moment(server_time).isBefore(current.batches[0].begin_at)
                console.log '第一批开售前'
                oneYuan =
                    <IconYiYuan />
                    # <a href="#" className="icon-1-yuan">
                    #     <img src="/images/presales/ico-1yuan.png" />
                    # </a>
                time =
                    <div>
                        <span className="u-color-gray-summary">首发预订时间：</span>
                        <span>{current.begin_at}</span>
                    </div>
        # 定金节点
        earnest_money_node =
            <div className="u-f14">
                预付定金：￥{earnest_money}
            </div>
        # 预售完毕
        if moment(current.end_at).isBefore(server_time)
            console.log '预售完毕'
            time = ''
            price_name = '折扣价'
            presale_price = sku.price
            earnest_money_node =
                <div className="u-f14">&nbsp;</div>

        <section>
            <div className="u-color-red u-f14 u-pr">
                {price_name}：￥{presale_price}
                <span className="u-del u-color-gray-summary u-ml-5">￥{sku.basic_price}</span>
            </div>
            {earnest_money_node}
            {time}
        </section>


module.exports = View
