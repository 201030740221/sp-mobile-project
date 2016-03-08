
store = liteFlux.store "point",
    data:
        size: 20
        list: null
        available_point: null
        total_point: null
        expiring_point: null


    actions:

        reset: (data) ->
            @setStore data

        getList: (data) ->
            store = @getStore()
            # TODO: 获取积分接口
            postData =
                size: store.size || 20
            if data
                postData = SP.assign postData, data
            webapi.point.getPointList(postData).then (res) =>
                SP.requestProxy(res).then (res)=>
                    if store.list isnt null and store.list.data and store.list.data.length
                        res.data.data = store.list.data.concat res.data.data
                        @setStore list: res.data
                    else
                        @setStore list: res.data

            # 临时数据
            # data =
            #     current_page: 1
            #     from: 1
            #     last_page: 10
            #     per_page: 10
            #     to: 10
            #     total: 261
            #     data:[
            #         type: '交易获得'
            #         source: '订单编号: 12939'
            #         point: 100
            #         created_at: "2015-07-01 14:19:25"
            #     ,
            #         type: '交易获得'
            #         source: '订单编号: 12939'
            #         point: -100
            #         created_at: "2015-07-01 14:19:25"
            #     ,
            #         type: '交易获得'
            #         source: '订单编号: 12939'
            #         point: 100
            #         created_at: "2015-07-01 14:19:25"
            #
            #     ]
            #
            # @setStore list: data

        loadMore: () ->
            store = @getStore()
            page = 1
            SP.log store.list
            if store.list and store.list.current_page
                page = store.list.current_page + 1

            @getAction().getList
                page: page

            # 临时数据
            # data =
            #     current_page: page
            #     from: 1
            #     last_page: 10
            #     per_page: 10
            #     to: 10
            #     total: 261
            #     data:[
            #         type: '交易获得'
            #         source: '订单编号: 12939'
            #         point: 100
            #         created_at: "2015-07-01 14:19:25"
            #     ,
            #         type: '交易获得'
            #         source: '订单编号: 12939'
            #         point: -100
            #         created_at: "2015-07-01 14:19:25"
            #     ,
            #         type: '交易获得'
            #         source: '订单编号: 12939'
            #         point: 100
            #         created_at: "2015-07-01 14:19:25"
            #
            #     ]
            # data.data = store.list.data.concat data.data
            #
            # @setStore list: data


        getPoint: () ->
            # TODO: 获取积分接口
            webapi.point.getPointStatistics().then (res) =>
                SP.requestProxy(res).then (res)=>
                    @setStore res.data
                    A('checkout').onChange res.data.available_point, 'available_point'
            # 临时数据
            # data =
            #     available_point: 10000000
            #     total_point: 120000000
            #     expiring_point: 0
            # @setStore data
            # A('checkout').onChange data.available_point, 'available_point'



module.exports = store;
