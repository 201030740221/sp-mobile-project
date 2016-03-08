liteFlux = require('lite-flux')
transformData = require 'modules/lib/mixins/transformData'

store = liteFlux.store "order-list",{
    data:
        showHandleModal: false,
        status_id: 0,
        begin_at: false,
        current_page: 1
        last_page:0
        data: []
    actions:
        getOrderList: (page)->
            self = this
            store = this.getStore()
            data = {
                page: page || 1
            }
            if store.status_id
                data.status_id = store.status_id
            if store.begin_at
                data.begin_at = "3_months_ago"
            else
                data.begin_at = "3_months_inner"

            SP.loading true
            webapi.order.getOrderList(data).then (res)=>
                SP.requestProxy(res).then (result)->

                    store = self.getStore()
                    olddata = store.data;
                    newdata = transformData._transformOrders(result.data.data)

                    newStore = {}
                    newStore.current_page = result.data.current_page
                    newStore.from = result.data.from
                    newStore.last_page = result.data.last_page
                    newStore.per_page = result.data.per_page
                    newStore.to = result.data.to
                    newStore.total = result.data.total
                    newStore.data = []

                    if page and page > 1
                        newStore.data = olddata.concat(newdata)
                    else
                        newStore.data = newdata

                    self.setStore newStore
                SP.loading false
    }

module.exports = store;
