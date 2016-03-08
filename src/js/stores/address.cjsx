
store = liteFlux.store "address",
    data:
        list: null

    actions:
        getAddress: () ->
            webapi.address.get().then (res) =>
                SP.requestProxy(res).then (res)=>
                    @getAction().setAddressList res.data
                    # @setStore
                    #     list: res.data
                    # checkout = liteFlux.store("checkout")
                    # if checkout? and checkout.getStore()? and checkout.getStore().address is null
                    #     res.data.map (item, i) ->
                    #         if item.is_default is 1
                    #             checkout.getAction().setAddress item

        setAddressList: (data) ->
            @setStore
                list: data
            checkout = liteFlux.store("checkout")
            if checkout? and checkout.getStore()? and checkout.getStore().address is null
                data.map (item, i) ->
                    if item.is_default is 1
                        checkout.getAction().setAddress item

        setDefaultAddress: (item) ->
            webapi.address.setDefault(item.id).then (res) =>
                SP.requestProxy(res).then (res)=>
                    SP.message
                        msg: '设置成功'
                    @getAction().setAddressList res.data
                    A('checkout').setAddress item


        setCheckoutAddress: (item, type) ->
            checkout = liteFlux.store("checkout")
            if checkout?
                checkout.getAction().setAddress item
                switch type
                    when 'checkout'
                        SP.redirect "/checkout"
                    when 'exchange'
                        SP.redirect "/exchange/checkout"
            else
                SP.log "没有checkout数据."
                SP.redirect "/cart"


        deleteAddress: (id) ->
            webapi.address.remove(id).then (res) =>
                SP.requestProxy(res).then ()=>
                    data = []
                    @getStore().list.map (item, i) ->
                        data.push item if item.id isnt id

                    @getAction().setAddressList data



module.exports = store;
