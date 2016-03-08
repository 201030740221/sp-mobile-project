store = liteFlux.store "comment",
    data:
        show: no
        size: 20
        list: null

    actions:
        init: () ->

        reset: () ->
            @setStore
                show: no
                size: 20
                list: null

        showModal: (status) ->
            @setStore
                show: status || no

        getList: (data) ->
            store = @getStore()
            postData =
                size: store.size || 20
            if data
                postData = SP.assign postData, data
            webapi.goods.getComment(postData).then (res) =>
                SP.requestProxy(res).then (res)=>
                    if store.list isnt null and store.list.data and store.list.data.length
                        res.data.data = store.list.data.concat res.data.data
                        @setStore list: res.data
                    else
                        @setStore list: res.data

        loadMore: (data) ->
            store = @getStore()
            page = 1
            SP.log store.list
            postData = {}
            if store.list and store.list.current_page
                postData.page = store.list.current_page + 1
            if data
                postData = SP.assign postData, data
            @getAction().getList postData


module.exports = store;
