transformData = require 'modules/lib/mixins/transformData'
assign = require 'object-assign'

store = liteFlux.store "suggestion",{
    data:
        'list': []
        'keyword': ''
    actions:
        resetList: () ->
            @setStore
                list: []

        list: (data, callback)->
            if !data.q
                this.setStore
                    list: []
                    keyword: ''
                return;

            webapi.goods.suggestion(data).then (res)=>
                this.setStore
                    list: res.data || []
                    keyword: data.q

                if callback then callback(res.data)
    }

module.exports = store;
