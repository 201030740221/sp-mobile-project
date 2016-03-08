store = liteFlux.store "activity-november-4",
    data:
        tab: 0

    actions:
        init: () ->

        reset: () ->
            @setStore
                tab: 0

        tab: (n) ->
            @setStore
                tab: n

        getPageData: () ->

            webapi.activity.getNovemberThird().then (res) =>
                console.log res
                SP.requestProxy(res).then (res)=>
                    @setStore res.data

        addToCart: (data) ->
            param =
                is_multiple: 1
                items: data
                quantity: 1
            promise = webapi.cart.add(param)
            promise.then (res)=>
                SP.requestProxy(res).then (res)=>
                    liteFlux.action("cart").updateCart res.data
                    SP.message
                        msg: '已加入购物车'
                if res.code isnt 0
                    SP.message
                        msg: res.msg

            promise


module.exports = store;
