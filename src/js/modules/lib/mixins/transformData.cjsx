module.exports =
    # 转换商品收藏列表数据数组
    _transformGoods: (data)->
        data.map (item)->
            id: item.goods_id  # ID
            sku_id: item.goods.primary_sku_id  # skuID
            img: item.goods.goods_sku.has_cover.media.full_path # 图片
            title: item.goods.title # 标题
            subtitle: item.goods.subtitle # 副标题
            price: item.goods.goods_sku.goods_sku_price.basic_price # 价格
            sku_sn: item.goods.goods_sku.sku_sn

    # 商品列表页面
    _transGoodsList: (data)->
        data = data || []
        data.map (item)->
            id: item.goods_id  # goods_id
            sku_id: item.goods_sku_id #sku_id
            img: item.full_path # 图片
            title: item.title # 标题
            subtitle: item.subtitle # 副标题
            price: item.price # 价格
            basic_price: item.basic_price # 价格
            sku_sn: item.sku_sn #sku_sn

    _transformOrders: (data)->
        self = this
        res = []
        data.map (item)->
            res.push {
                type: item.type
                total: item.total #总价格
                order_no: item.order_no # 订单号
                status_id: item.status_id # 交易状态 ID
                status: self._transformOrderDetail(item).status
                goods: self._transformOrderGoods(item)
                created_at: item.created_at
                presale_status: item.presale_status if item.type is 1
                earnest_money: item.phases.earnest_money.price if item.type is 1
                balance_due: item.phases.balance_due.price if item.type is 1
                pay_deadline: item.presale.presaleBatch.pay_deadline if item.type is 1
                booking_expire: item.presale.presaleBatch.booking_expire if item.type is 1
            }
        res
    # 转换订单商品列表
    _transformOrderGoods: (data)->
        res = []
        detail = this._transformOrderDetail(data)
        detail.goods.map (item)->
            if item.goods_sku.has_cover
                cover = item.goods_sku.has_cover.media.full_path
            else
                cover = ''
            res.push {
                key: item.order_no+"_"+item.id
                title: item.goods_sku.goods.title  # ID
                goods_type: item.goods_type
                presale_status: detail.presale_status if detail.presale_status
                goods_sku:[
                    cover: cover
                    price: item.price
                    earnest_money: detail.earnest_money if data.phases
                    balance_due: detail.balance_due if data.phases
                    basic_price: item.goods_sku.goods_sku_price.basic_price
                    quantity: item.amount
                    attribute: item.goods_sku.attribute_name
                ]
            }
        res
    # 转换订单商品详情
    _transformOrderDetail: (data)->
        detail = data
        status_id = data.status_id
        detail.goods_title = data.goods[0].goods_sku.goods.title
        detail.status = switch
            when status_id is 1 then '等待付款'
            when status_id is 2 then '付款成功'
            when status_id is 3 then '等待发货'
            when status_id is 4 then '等待收货'
            when status_id is 5 then '订单已完成'
            when status_id is 6 then '订单已取消'

        if  data.type is 1
            detail.earnest_money = data.phases.earnest_money.price
            detail.balance_due = data.phases.balance_due.price
            type = data.payment_phase.type

            detail.presale_status = switch
                when (status_id is 1) and (type is 0) then 0 # 未支付定金
                when (status_id is 1) and (type is 1) then 1 # 已支付定金未支付尾款
                when [2, 3, 4].indexOf(status_id) isnt -1 then 2 # 已支付尾款，完成支付
                when status_id is 5 then 3 # 订单完成
                when status_id is 6 then -1 # 订单已取消

        detail
