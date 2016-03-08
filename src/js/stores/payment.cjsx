transformData = require 'modules/lib/mixins/transformData'

store = liteFlux.store "payment",
    data:
        order: null
        partner_id: 1

    actions:
        reset: () ->
            @setStore
                order: null

        init: (order_no) ->
            @getAction().reset() if @getStore().order isnt null
            if !order_no or isNaN order_no
                SP.redirect '/member/order/all', true
            webapi.order.getOrderDetail(order_no: order_no).then (res)=>
                SP.requestProxy(res).then (res)=>
                    data = res.data
                    data.detail = transformData._transformOrderDetail(data.detail)
                    @setStore
                        order: data
                # 订单不是该用户的, 跳回订单列表
                if res.code is 20005
                    SP.redirect '/member/order/all', true

        setPaymentMethod: (id) ->
            @setStore
                partner_id: id




module.exports = store;
