store = liteFlux.store "cart",{
    data:
        unselected:{}

    actions:
        resetUnselected: () ->
            @setStore
                unselected: {}
        updateCart: (data) ->

            # set Member storage
            A("member").setTotalQuantity data.total_quantity

            # set Cart
            data.items = data.items || []
            @setStore data

        getCart: () ->
            webapi.cart.get().then (res) =>
                # SP.message
                #     msg: '获取购物车数据成功'
                SP.requestProxy(res).then (res)=>
                    @getAction().updateCart res.data

        deleteItems: (listCheckedState) ->
            store = @getStore()
            item_keys = @getAction().getSelectedItems()
            if item_keys.length
                data =
                    item_keys: item_keys
                webapi.cart.remove(data).then (res) =>
                    SP.requestProxy(res).then (res)=>
                        @getAction().updateCart res.data
                        SP.message
                            msg: '已成功删除商品'
                            type: 'success'

                    if res.code isnt 0
                        SP.message
                            msg: res.msg

        updateSku: (id, value) ->
            data =
                item_key: id
                quantity : value
            webapi.cart.update(data).then (res) =>
                SP.requestProxy(res).then (res)=>
                    @getAction().updateCart res.data
                if res.code isnt 0
                    SP.message
                        msg: res.msg
                # # CODE = 1 积分不足...目前只有这种情况
                # if res.code is 1
                #     SP.message
                #         msg: '您的可用积分不足'
                #     @getAction().updateCart res.data

        # select: (id, value) ->
        #     value = if value is true then 1 else 0
        #     data =
        #         item_key: id
        #         select : value
        #     webapi.cart.select(data).then (res) =>
        #         SP.requestProxy(res).then (res)=>
        #             @getAction().updateCart res.data
        #
        #         if res.code isnt 0
        #             SP.message
        #                 msg: res.msg
        #
        # selectAll: (value) ->
        #     value = if value is true then 1 else 0
        #     data =
        #         select : value
        #     webapi.cart.select(data).then (res) =>
        #         SP.requestProxy(res).then (res)=>
        #             @getAction().updateCart res.data
        #
        #         if res.code isnt 0
        #             SP.message
        #                 msg: res.msg


        select: (id, value) ->
            store = @getStore()
            unselected = store.unselected
            unselected[id] = not value
            @setStore
                unselected: unselected

        selectAll: (value) ->
            store = @getStore()
            unselected = {}
            if value
                @setStore
                    unselected: {}
            else
                if store.items and store.items.length
                    store.items.map (item, i) =>
                        unselected[item.id] = yes
                @setStore
                    unselected: unselected

        getSelectedItems: () ->
            store = @getStore()
            unselected = store.unselected
            item_keys = []
            if store.items and store.items.length
                store.items.map (item, i) =>
                    if not unselected[item.id]
                        item_keys.push item.id
            item_keys

        isAllOnSale: () ->
            store = @getStore()
            unselected = store.unselected
            allOnSale = yes
            if store.items and store.items.length
                store.items.map (item, i) =>
                    if not unselected[item.id]
                        if item.is_multiple is yes
                            item.items.map (subItem, j) ->
                                if subItem.on_sale is 0
                                    allOnSale = no
                        else
                            if item.items.on_sale is 0
                                allOnSale = no
            allOnSale

        isSelectedAtLeastOne: () ->
            store = @getStore()
            unselected = store.unselected
            status = no
            if store.items and store.items.length
                store.items.map (item, i) =>
                    if not unselected[item.id]
                        status = yes
            status

        isSelectedAll: () ->
            store = @getStore()
            unselected = store.unselected
            status = yes
            if store.items and store.items.length
                store.items.map (item, i) =>
                    if unselected[item.id]
                        status = no
            status

        checkout: () ->

            checkout = S('checkout')
            store = @getStore()
            isAllOnSale = @getAction().isAllOnSale()
            if isAllOnSale is no
                SP.message
                    msg: '已下架的商品无法结算!'
                return false
            item_keys = @getAction().getSelectedItems()
            if item_keys.length
                data =
                    item_keys: item_keys

                if checkout.address isnt null
                    region_id = checkout.address.district_id
                    data.region_id = region_id
                A('checkout').checkout data
                # webapi.cart.checkout(data).then (res) =>
                #     SP.requestProxy(res).then (res)=>
                #         checkout = liteFlux.store("checkout")
                #         checkout.getAction().onChange res.data, 'data'
                #         SP.redirect '/checkout'



            {
                goods_sku: []
            }

        addToCart: (goods_sku_id, quantity = 1, is_multiple = 0) ->
            data =
                is_multiple: is_multiple
                item: goods_sku_id
                quantity: quantity
            promise = webapi.cart.add(data)
            promise.then (res)=>
                SP.requestProxy(res).then (res)=>
                    @getAction().updateCart res.data
                    SP.message
                        msg: '已加入购物车'
                if res.code isnt 0
                    SP.message
                        msg: res.msg

            promise





}

module.exports = store;
