
store = liteFlux.store "service-card",
    data:
        code: ''
        list: null
        type: null
        keyMap: []
        valueMap:
            'usable': '可用'
            'unusable': '不可用'
            'unused': '未使用'
            'used': '已使用'
            'outdated': '已过期'


    actions:

        reset: (data) ->
            @setStore data

        getCoupon: (type) ->
            if type is 'checkout'
                checkoutStore = S 'checkout'
                webapi.coupon.getCheckoutCouponList({
                    total_price: checkoutStore.data.price.total_price
                    category_ids: checkoutStore.data.category_ids
                    goods_ids: checkoutStore.data.goods_ids
                    filter: 'installation-card'
                    client: 'mobile'
                }).then (res) =>
                    SP.requestProxy(res).then (res)=>
                        @setStore
                            list: res.data
            else
                webapi.coupon.getCouponMine({
                    filter: 'service-card'
                }).then (res) =>
                    SP.requestProxy(res).then (res)=>
                        @setStore
                            list: res.data

        onChange: (value, type) ->
            data = {}
            data[type] = value
            @setStore data

module.exports = store;
