
store = liteFlux.store "coupon",
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

        onModalShow: ->
            @setStore
                showModal: yes
        onModalHide: ->
            @setStore
                showModal: no

        getCoupon: (type) ->
            if type is 'checkout'
                checkoutStore = S 'checkout'
                webapi.coupon.getCheckoutCouponList({
                    total_price: checkoutStore.data.price.total_price
                    category_ids: checkoutStore.data.category_ids
                    goods_ids: checkoutStore.data.goods_ids
                    filter: 'coupon'
                    client: 'mobile'
                }).then (res) =>
                    SP.requestProxy(res).then (result)=>
                        @setStore
                            list: result.data
            else
                webapi.coupon.getCouponMine({
                    filter: 'coupon'
                }).then (res) =>
                    SP.requestProxy(res).then (result)=>
                        @setStore
                            list: result.data

        activateCoupon: (type) ->
            if validatorData.valid()
                data =
                    code: @getStore().code
                promise = webapi.coupon.activateCoupon(data)
                promise.then (res) =>
                    SP.requestProxy(res).then (res)=>
                        SP.message
                            msg: '优惠券兑换成功'
                        if type is 'checkout'
                            checkout = S 'checkout'
                            if checkout.data isnt null and checkout.data.price? and checkout.data.price.total_price
                                @getAction().getCoupon(type)
                            else
                                SP.redirect '/checkout'
                        else
                            @getAction().getCoupon()

                    # {
                    #   "code": 0,
                    #   "msg": "成功",
                    #   "data": true
                    # }
                    #
                    # {
                    #   "code": 20002,
                    #   "msg": "",
                    #   "data": {
                    #     "errors": {
                    #       "code": [
                    #         "兑换码必须填写"
                    #       ]
                    #     }
                    #   }
                    # }
                    #
                    # {
                    #   "code": 20002,
                    #   "msg": "",
                    #   "data": {
                    #     "errors": {
                    #       "code": [
                    #         "兑换码长度不可小于8"
                    #       ]
                    #     }
                    #   }
                    # }
                    #
                    # {
                    #   "code": 20001,
                    #   "msg": "操作频率限制",
                    #   "data": []
                    # }
                    #
                    # {
                    #   "code": 54001,
                    #   "msg": "兑换码不存在",
                    #   "data": []
                    # }
                    #
                    # {
                    #   "code": 54002,
                    #   "msg": "兑换码已被兑换",
                    #   "data": []
                    # }
                    #
                    # {
                    #   "code": 54003,
                    #   "msg": "兑换码已过兑换期",
                    #   "data": []
                    # }
                    #
                    # {
                    #   "code": 54004,
                    #   "msg": "兑换码已禁用",
                    #   "data": []
                    # }
                    if res.code is 20002
                        if res.data.errors
                            @setStore
                                fieldError: res.data.errors
                        SP.message
                            msg: '请输入有效的兑换码'
                    if res.code is 20001 or res.code > 50000
                        SP.message
                            msg: res.msg

                    promise
                promise
            else
                no


        onChange: (value, type) ->
            data = {}
            data[type] = value
            @setStore data


Validator = liteFlux.validator
validatorData = Validator store,{
    'code':
        required: true
        minLength: 8
        message:
            required: "兑换码不能为空"
            minLength: "请输入有效的兑换码"
},{
    #oneError: true
}

store.addAction 'valid', ->
    validatorData.valid()


module.exports = store;
