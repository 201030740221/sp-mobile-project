liteFlux = require('lite-flux')
transformData = require 'modules/lib/mixins/transformData'

store = liteFlux.store "order-detail",{
    data:
        toolThrough: true,
        detail: {
            goods: [],
            delivery:{
                member_address: {
                    consignee: ''
                }
            }
        }
    actions:
        init: (order_no)->
            self = this
            data = {
                order_no: order_no
            }
            webapi.order.getOrderDetail(data).then (res)=>
                SP.requestProxy(res).then (data)->
                    result = self.getStore()
                    result.detail = transformData._transformOrderDetail(data.data.detail)
                    result.detail.goods = transformData._transformOrderGoods(data.data.detail)
                    self.setStore result
                # 订单不是该用户的, 跳回订单列表
                if res.code is 20005
                    SP.redirect '/member/order/all', true

    }

module.exports = store;
