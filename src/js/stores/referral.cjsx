
store = liteFlux.store "referral",
    data:
        list: []
        active: 0
        total_members: 0
        total_points: 0
        current_page: null
        last_page: null
        is_weixin: true
        link: null


    actions:

        onChangeTab: (index)->
            @setStore
                active: index
        getList: (page)->
            self = this
            webapi.referral.getReferralLog({
                page: page || 1
            }).then (res)->
                SP.requestProxy(res).then ()->

                    store = self.getStore()
                    olddata = store.list

                    newStore = {}
                    newStore.current_page = res.data.current_page
                    newStore.last_page = res.data.last_page
                    newStore.total_members = res.data.total
                    newStore.total_points = res.data.points
                    newStore.link = res.data.link
                    newStore.qrcode = res.data.qrcode
                    newStore.list = []

                    if page and page > 1
                        newStore.list = olddata.concat(res.data.data)
                    else
                        newStore.list = res.data.data

                    self.setStore newStore




module.exports = store;
