store = liteFlux.store "presales-home",
    data:
        list: null
        current: null
        tab: 0

    actions:
        reset: () ->
            list: null
            current: null
            tab: 0
        setCurrent: (item) ->
            @setStore
                current: item

        tab: (i) ->
            store = @getStore()
            list = store.list
            current = list[i]
            A('presales-detail').reset()
            @setStore
                tab: i
                current: current
            A('presales-detail').getPresales current.id
            # A('presales-detail').initPresales currnet, store.server_time
        getList: () ->
            webapi.presales.presales().then (res) =>
                SP.requestProxy(res).then (res)=>
                    current = null
                    if res.data and res.data.presales and res.data.presales.length
                        current = res.data.presales[0]
                        A('presales-detail').reset()
                        A('presales-detail').getPresales current.id
                    @setStore
                        list: res.data.presales
                        current: current
                        server_time: res.data.server_time

module.exports = store;
