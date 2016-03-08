liteFlux = require('lite-flux');
transformData = require 'modules/lib/mixins/transformData'

store = liteFlux.store "member-favorite",
    data:
        current_page: 1
        data: []
        from: 1
        last_page: 1,
        per_page: 20,
        to: 5,
        total: 5
    actions:
        getFavoriteList: (page)->
            self = this

            SP.loading true

            webapi.member.favorite({
                page: page || 1
            }).then (res)=>
                SP.requestProxy(res).then (result)->

                    store = self.getStore()
                    olddata = store.data;
                    result.data.data = transformData._transformGoods(result.data.data)

                    newStore = {}
                    newStore.current_page = result.data.current_page
                    newStore.from = result.data.from
                    newStore.last_page = result.data.last_page
                    newStore.per_page = result.data.per_page
                    newStore.to = result.data.to
                    newStore.total = result.data.total
                    newStore.data = []

                    if page and page > 1
                        newStore.data = olddata.concat(result.data.data)
                    else
                        newStore.data = result.data.data

                    self.setStore newStore
                SP.loading false

        removeFavorite: (id,index)->
            self = this
            state = this.getStore()
            webapi.member.favoriteDelete({
                goods_ids: JSON.stringify([id])
            }).then (res)->
                SP.requestProxy(res).then (result)->
                    if(result.code==0)
                        SP.message
                            msg: "删除收藏成功"
                        # 更新页面
                        state.data = SP.removeArray(state.data,index)
                        self.setStore(state);
                    else
                        SP.message
                            msg: "删除收藏失败"
                        # 更新页面

module.exports = store
