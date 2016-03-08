
store = liteFlux.store "invoice",
    data:
        current: null
        list: null
        type: 0
        title_type: 0
        content_type: 0
        company_name: ""
        showModal: no


    actions:

        reset: () ->
            data =
                current: null
                type: 0
                title_type: 0
                content_type: 0
                company_name: ""
                showModal: no

            @setStore data


        onModalShow: ->
            @setStore
                showModal: yes
        onModalHide: ->
            @setStore
                showModal: no

        getInvoice: () ->
            webapi.invoice.getInvoiceList().then (res) =>
                SP.requestProxy(res).then (result)=>
                    @setStore
                        list: result.data

        deleteInvoice: (id) ->
            webapi.invoice.deleteInvoice(id).then (res) =>
                SP.requestProxy(res).then (result)=>
                    result.data = []
                    @getStore().list.map (item, i) ->
                        result.data.push item if item.id isnt id
                    @setStore
                        list: result.data

        setTitleType: (type) ->
            @setStore
                title_type: type

        onChange: (value, type) ->
            data = {}
            data[type] = value
            @setStore data
            validatorData.valid(type) if type is 'company_name'

        save: () ->
            store = @getStore()
            data =
                type: 0
                title_type: store.title_type
                content_type: 0
            if store.title_type is 1
                data.company_name = store.company_name

            if store.current isnt null and store.current.id?
                data.id = store.current.id
                webapi.invoice.updateInvoice(data).then (res) =>
                    SP.requestProxy(res).then (result)=>
                        SP.message
                            msg: '发票修改成功'
                        @setStore
                            list: result.data
                        @getAction().reset()

            else
                webapi.invoice.createInvoice(data).then (res) =>
                    SP.requestProxy(res).then (result)=>
                        SP.message
                            msg: '发票保存成功'
                        @setStore
                            list: result.data
                        @getAction().reset()

        setCurrent: (data, show) ->
            @setStore
                current: data
                title_type: data.title_type
                company_name: data.company_name
                showModal: show || no





Validator = liteFlux.validator
validatorData = Validator store,{
    'company_name':
        required: true
        minLength: 1
        maxLength: 60
        message:
            required: "单位名称不能为空"
            minLength: "单位名称不能少于1个字符"
            maxLength: "单位名称不能多于60个字符"
},{
    #oneError: true
}

store.addAction 'valid', ->
    validatorData.valid()




module.exports = store;
