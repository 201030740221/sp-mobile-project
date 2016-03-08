moment = require 'moment'
Validator = liteFlux.validator

# mydata = require './checkout-data.js'
# mydata = JSON.parse(mydata).data

store = liteFlux.store "checkout",
    data:
        address: null
        data: null
        member_address_id: ''
        reserve_delivery_time: ''
        reserve_installation_time: ''
        invoice_id: ''
        invoice_text: ''
        note: ''
        coupon_ids: ''
        coupon_text: ''
        exchange: null
        available_point: null
        point_state: false
        service_card: null
        sms_mobile: ''
        earnest_money_pay_agree: yes # 是否同意支付定金

    actions:
        init: () ->
            store = @getStore()
            @setStore 'sms_mobile': S("member").mobile if store.data and store.data.presale is 1

        reset: () ->
            @setStore
                address: null
                data: null
                member_address_id: ''
                reserve_delivery_time: ''
                reserve_installation_time: ''
                invoice_id: ''
                invoice_text: ''
                note: ''
                coupon_ids: ''
                coupon_text: ''
                exchange: null
                available_point: null
                point_state: false
                service_card: null

        getItemKeys: () ->
            store = @getStore()
            store.data.items.items.map (item, i) =>
                item.id

        setAddress: (item) ->
            @setStore
                address: item
                member_address_id: item.id

            if @getStore().data isnt null and item.id?
                region_id = item.district_id
                # 重新计算价格
                store = @getStore()
                data =
                    region_id: region_id
                if store.coupon_ids
                    data.coupon_ids = store.coupon_ids
                if store.service_card
                    data.coupon_ids = if data.coupon_ids then data.coupon_ids + ',' + store.service_card.id else store.service_card.id

                @getAction().getCheckoutPrice(data, =>
                    # 用地址获得价格后重新提交积分拿最终价格
                    if store.point_state and store.available_point > 0
                        total = SP.calc.Add store.data.price.total, 0
                        total = 0 if total < 0
                        total = SP.calc.Mul total, 100
                        if total > store.available_point
                            data.point = store.available_point
                        else
                            data.point = total

                    @getAction().getCheckoutPrice(data)
                );
                @getAction().getPredictDelivery region_id: region_id

        getPredictDelivery: (data) ->
            webapi.checkout.getPredictDelivery(data).then (res) =>
                SP.requestProxy(res).then (res)=>
                    store = @getStore()
                    checkoutData = store.data
                    checkoutData.shipping_date = res.data
                    last_days = @getAction().getLastDays res.data
                    @setStore
                        reserve_delivery_time: res.data.start.split(' ')[0]
                        reserve_installation_time: res.data.start.split(' ')[0]
                        last_date: res.data.end
                        last_days: last_days
                        data: checkoutData
        getLastDays: (shipping_date) ->
            start_moment = moment shipping_date.start
            end_moment = moment shipping_date.end
            end_moment.diff start_moment, 'days'

        getCheckoutPrice: (data, callback) ->
            store = @getStore()

            data.item_keys = @getAction().getItemKeys()
            data.quickbuy = 1 if store.data.quickbuy is 1
            data.exchange = 1 if store.data.exchange is 1
            data.client = 'mobile'
            data.presale = 1 if store.data.presale is 1

            if store.data.flash_sale_id
                data.flashsale = 1

            webapi.checkout.getCheckoutPrice(data).then (res) =>
                SP.requestProxy(res).then (res)=>
                    data = store.data
                    data.price = res.data
                    @setStore
                        data: data
                    if callback
                        callback()

        autoGetCheckoutPrice: () ->
            store = @getStore()
            if store.address isnt null and store.member_address_id isnt '' and store.data isnt null
                region_id = store.address.district_id
                data =
                    region_id: region_id
                if store.coupon_ids
                    data.coupon_ids = store.coupon_ids
                if store.service_card
                    data.coupon_ids = if data.coupon_ids then data.coupon_ids + ',' + store.service_card.id else store.service_card.id
                if store.point_state and store.available_point > 0
                    # point_abatement = 0
                    # if store.data.price.point_abatement
                    #     point_abatement = store.data.price.point_abatement
                    # total = SP.calc.Add store.data.price.total, point_abatement
                    # total = SP.calc.Add store.data.price.total, point_abatement
                    # total = 0 if total < 0
                    # total = SP.calc.Mul total, 100
                    # total = store.available_point if total > store.available_point
                    total = @getAction().getUsedPoint()
                    data.point = total
                @getAction().getCheckoutPrice data
            else
                SP.message
                    msg: '请先选择收货地址'

        setDate: (date, type) ->
            switch type
                when 'delivery'
                    @setStore
                        reserve_delivery_time: date
                        reserve_installation_time: date
                when 'install'
                    if @getStore().reserve_delivery_time is ''
                        @setStore
                            reserve_delivery_time: date
                            reserve_installation_time: date
                    else
                        @setStore
                            reserve_installation_time: date

        onChange: (value, type) ->
            data = {}
            data[type] = value
            @setStore data

            if (type is 'point_state') or (type is 'coupon_ids') or (type is 'service_card')
                @getAction().autoGetCheckoutPrice()

        getUsedPoint: () ->
            data = @getStore()
            # available_point = SP.calc.Sub data.available_point, data.price.total_point
            # total_point = SP.calc.Mul data.data.price.total, 100
            # total_point = available_point if total_point > available_point

            available_point = SP.calc.Sub data.available_point || 0, data.data.price.total_point || 0
            point_abatement = 0
            if data.data.price.point_abatement
                point_abatement = data.data.price.point_abatement
            total = SP.calc.Add data.data.price.total, point_abatement
            total = 0 if total < 0
            total = SP.calc.Mul total, 100
            total = available_point if total > available_point
            total = 0 if not (available_point > 0)

            total

        # 预售商品同意支付定金Checkbox
        onCheckbox: (checked) ->
            @setStore 'earnest_money_pay_agree': checked

        checkPresaleState: ->
            # store = @getStore()
            if not store.earnest_money_pay_agree
                SP.message
                    msg: '请同选择意支付定金'
                return false

            if not @getAction().check_mobile()
                SP.message
                    msg: @getStore().fieldError['sms_mobile'][0]
                return false

            return true

        submit: () ->
            store = @getStore()
            if store.data && store.data.flash_sale_id
                data =
                    member_address_id: store.member_address_id
                    reserve_delivery_time: store.reserve_delivery_time
                    reserve_installation_time: store.reserve_installation_time
                    flashsale: 1
                    flash_sale_id: parseInt(store.data.flash_sale_id)
                    item_keys: @getAction().getItemKeys()
            else
                data =
                    member_address_id: store.member_address_id
                    reserve_delivery_time: store.reserve_delivery_time
                    reserve_installation_time: store.reserve_installation_time
                    invoice_id: store.invoice_id
                    note: store.note
                    coupon_ids: store.coupon_ids
                    item_keys: @getAction().getItemKeys()

                data.quickbuy = 1 if @getStore().data.quickbuy is 1
                data.exchange = 1 if @getStore().data.exchange is 1
                # 预售订单需要的数据
                data.order_type = if store.data.presale is 1 then 1 else 0
                data.presale = if store.data.presale is 1 then 1 else 0
                data.presale_id = store.data.presale_id if store.data.presale is 1
                data.presale_batch_id = store.data.presale_batch_id if store.data.presale is 1
                data.balance_due_reminder_mobile = store.sms_mobile if store.data.presale is 1

                if store.service_card
                    data.coupon_ids = if data.coupon_ids then data.coupon_ids + ',' + store.service_card.id else store.service_card.id
            if store.point_state
                data.point = @getAction().getUsedPoint()
            if not data.member_address_id
                SP.message
                    msg: '请添加收货地址'
                return 0

            if store.data.presale is 1
                return 0 unless @getAction().checkPresaleState()

            # 1:PC, 2: M端, 3: IOS, 4:Android
            data.source = 2
            data.client = 'mobile'
            webapi.checkout.submit(data).then (res) =>
                SP.requestProxy(res).then (res)=>
                    if res.code == 0
                        SP.log res.data
                        # 99click 订单下单成功
                        # and pageHistory.stack.length and pageHistory.getCurrent().url == '/checkout'
                        if sipinConfig.env == "production"
                            webapi.tools.orderAnalytics({
                                order_no: res.data.order && res.data.order.order_no
                            }).then (result)->
                                if result && result.code == 0
                                    liteFlux.event.emit('click99',"checkout", result.data.code);

                        # 跳转
                        order = res.data.order
                        # 金额大于0的订单
                        if order and order.status_id is 1
                            SP.redirect "/payment/" + order.order_no
                        # 金额等于0的订单
                        else if order and (order.status_id is 2 or order.status_id is 5)
                            #99click 订单下单成功
                            if sipinConfig.env == "production"
                                webapi.tools.orderAnalytics({
                                    order_no: order.order_no
                                }).then (result)->
                                    if result && result.code == 0
                                        liteFlux.event.emit('click99',"order-complete", result.data.code);
                            SP.redirect "/member/order/detail/" + order.order_no
                        # 清空checkout数据
                        @getAction().reset()
                        # 更新购物车
                        A('cart').getCart()
                .catch (err)->
                    if res.code == 1
                        SP.message
                            msg: res.msg
                    else if res.code == 20002
                        SP.message
                            msg: "非法提交订单"
        quickbuy: (sku_id, quantity = 1, region_id, is_multiple = 0) ->
            @getAction().reset()
            data =
                item: sku_id
                quantity: quantity
                is_multiple: is_multiple
            data.region_id= region_id if region_id
            webapi.cart.quickbuy(data).then (res) =>
                SP.requestProxy(res).then (res)=>
                    @getAction().setCheckoutData res.data
                    SP.redirect '/checkout'
                if res.code is 40001 or res.code is 40003
                    # console.log res
                else if res.code isnt 0
                    SP.message
                        msg: res.msg


        exchange: (sku_id, quantity = 1, region_id, is_multiple = 0) ->
            @getAction().reset()
            data =
                item: sku_id
                quantity: quantity
                is_multiple: is_multiple
            data.region_id= region_id if region_id
            promise = webapi.cart.exchange(data)
            promise.then (res) =>
                SP.requestProxy(res).then (res)=>
                    @getAction().setCheckoutData res.data
                    SP.redirect '/checkout'

                if res.code is 40001 or res.code is 40003
                    # console.log res
                else if res.code isnt 0
                    SP.message
                        msg: res.msg
            promise

        checkout: (data, type) ->
            @getAction().reset()

            # if data and ( data.goods_sku or (data.goods_sku_id and data.goods_sku_quantity) or data.flash_sale_id )
            #     webapi.cart.checkout(data).then (res) =>
            #
            #         # 秒杀操作
            #         if data.flash_sale_id
            #             # 手动判断 登录完成直接checkout
            #             if res.code is 40001 or res.code is 40003
            #                 SP.loadLogin
            #                     success: =>
            #                         @getAction().checkout data
            #             else if res.code == 50001
            #                 SP.message
            #                     msg: res.msg
            #             else if res.code == 50002 || res.code == 50003
            #                 SP.message
            #                     msg: "请求信息错误，请重试！"
            #                 SP.redirect '/404'
            #             else if res.code == 50004
            #                 # 进入下单页
            #                 @getAction().onChange res.data, 'data'
            #                 SP.redirect '/checkout'
            #             else if res.code == 50005
            #                 # 进入支付页
            #                 SP.redirect '/payment/'+ res.data.order_no
            #             else if res.code == 50006
            #                 # 进入支付页
            #                 SP.redirect '/member/order/all'
            #             else
            #                 SP.requestProxy(res).then (res)=>
            #
            #         # 后端登录后没有合并购物车数据, so 只能刷新页面, 无法直接checkout
            #         if data.goods_sku
            #             # SP统一判断 登录完刷新页面
            #             SP.requestProxy(res).then (res)=>
            #                 @getAction().onChange res.data, 'data'
            #                 SP.redirect '/checkout'
            #
            #             # 手动判断 登录完成直接checkout
            #             # if res.code is 40001 or res.code is 40003
            #             #     SP.loadLogin
            #             #                 success: =>
            #             #                     @getAction().checkout data
            #             #
            #             # else if res.code is 0
            #             #     @getAction().onChange res.data, 'data'
            #             #     SP.redirect '/checkout'
            #             # else
            #             #     SP.requestProxy(res).then (res)=>
            #
            #
            #
            #         # 立即购买可以直接checkout
            #         if data.goods_sku_id and data.goods_sku_quantity
            #             # 手动判断 登录完成直接checkout
            #             if res.code is 40001 or res.code is 40003
            #                 SP.loadLogin
            #                     success: =>
            #                         @getAction().checkout data
            #
            #             else if res.code is 0
            #                 @getAction().onChange res.data, 'data'
            #                 SP.redirect '/checkout'
            #             else
            #                 SP.requestProxy(res).then (res)=>
            #
            #         # CODE = 1 积分不足...目前只有这种情况
            #         if res.code is 1
            #             SP.message
            #                 msg: res.msg

            apiName = 'checkout'
            isFlashsale = type is 'flashsale'
            if isFlashsale
                apiName = 'checkoutFlashsale'

            if data.item_keys and data.item_keys.length or isFlashsale
                webapi.cart[apiName](data).then (res) =>
                    # 秒杀操作
                    if isFlashsale
                        # 手动判断 登录完成直接checkout
                        if res.code is 40001 or res.code is 40003
                            SP.loadLogin
                                success: =>
                                    @getAction().checkout data
                        else if res.code == 50001
                            SP.message
                                msg: res.msg
                        else if res.code == 50002 || res.code == 50003
                            SP.message
                                msg: "请求信息错误，请重试！"
                            SP.redirect '/404'
                        else if res.code == 50004
                            # 未下单，进入下单页
                            @getAction().setCheckoutData res.data
                            SP.redirect '/checkout'
                        else if res.code == 50005
                            # 未支付，进入支付页
                            SP.redirect '/payment/'+ res.data.order_no
                        else if res.code == 50006
                            # 已支付，进入订单页
                            SP.redirect '/member/order/all'
                        # 处理完秒杀就终止
                        return true
                    #
                    SP.requestProxy(res).then (res)=>
                        @getAction().setCheckoutData res.data
                        SP.redirect '/checkout'

                    if res.code is 40001 or res.code is 40003
                        # console.log res
                        # SP.loadLogin
                        #     success: =>
                                # @getAction().checkout data
                    else if res.code isnt 0
                        SP.message
                            msg: res.msg


        checkoutPresales: (data) ->
            @getAction().reset()
            if data.presale_batch_id and data.sku_sn
                data =
                    presale_batch_id: data.presale_batch_id
                    sku_sn: data.sku_sn
                    quantity: data.quantity || 1
                webapi.presales.presalesBuy(data).then (res) =>
                    SP.requestProxy(res).then (res)=>
                        console.log 'code is 0'
                    if res.code is 50014
                        @getAction().setCheckoutData res.data
                        console.log res.data
                        SP.redirect '/checkout'
                    else if res.code is 50015
                        SP.redirect '/payment/'+ res.data.order_no
                    else if res.code is 40001 or res.code is 40003
                        # console.log res
                        # SP.loadLogin
                        #     success: =>
                                # @getAction().checkout data
                    else if res.code is 1 and res.msg is '请先登录'
                        SP.loadLogin
                            success: =>
                                window.location.reload()
                    else if res.code is 50015
                        SP.message
                            msg: '您已预订过该商品'
                    else if res.code isnt 0
                        SP.message
                            msg: res.msg


        setCheckoutData: (data) ->
            last_days = @getAction().getLastDays data.shipping_date
            @setStore
                data: data
                last_days: last_days
                last_date: data.shipping_date.end

validatorData = Validator store,{
    'sms_mobile':
        required: true
        phone: true
        message:
            required: "手机号码不能为空"
            phone: "请输入正确的手机号码"
},{
    #oneError: true
}

store.addAction 'check_mobile', ->
    validatorData.valid('sms_mobile')

module.exports = store;
