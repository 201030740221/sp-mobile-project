transformData = require 'modules/lib/mixins/transformData'
assign = require 'object-assign'

store = liteFlux.store "goods-list",{
    data:
        'goodsList': []
        'pager': {}
    actions:
        list: (data, loaded)->
            SP.loading(true)

            this.setStore
                'loading': true

            if data.keyword
                data.keyword = decodeURIComponent(data.keyword)

            webapi.goods.getGoodsList(data).then (res)=>
                SP.loading()

                goodsList = transformData._transGoodsList res.data.goods
                if res.data.pager.current_page > 1
                    goodsList = this.getStore().goodsList.concat goodsList

                this.setStore
                    'goodsList': goodsList
                    'pager': res.data.pager
                    'category': res.data.category
                    'loading': false

                loaded() if loaded
    }

module.exports = store;