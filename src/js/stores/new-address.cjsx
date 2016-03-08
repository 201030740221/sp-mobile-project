
store = liteFlux.store "newAddress",
    data:
        current: null
        address: ""
        consignee: ""
        mobile: ""
        second_mobile: ""
        email: ""
        is_default: 0

    actions:

        reset: () ->
            data =
                current: null
                address: ""
                consignee: ""
                mobile: ""
                second_mobile: ""
                email: ""
                is_default: 0

            @setStore data


        save: (type) ->
            store = @getStore()
            region = liteFlux.store('region').getStore()
            data =
                address: store.address
                consignee: store.consignee
                mobile: store.mobile
                second_mobile: store.second_mobile
                email: store.email
                province_id: region.province
                province_name: region.province_name
                city_id: region.city
                city_name: region.city_name
                district_id: region.district
                district_name: region.district_name

            if store.current isnt null and store.current.id?
                data.id = store.current.id
                # 后端要求更新的时候 回传 status
                data.status = store.status || 0
                webapi.address.update(data).then (res) =>
                    # console.log res
                    SP.message
                        msg: '地址修改成功'
                    @getAction().saveCallback type, res
                    # switch type
                    #     when "checkout"
                    #         redirect = "/checkout"
                    #         liteFlux.store('checkout').getAction().setAddress res.data[res.data.length - 1]
                    #     when "exchange"
                    #         redirect = "exchange/checkout"
                    #         liteFlux.store('checkout').getAction().setAddress res.data[res.data.length - 1]
                    #     when "profile"
                    #         redirect = "/member/address"
                    # @getAction().reset()
                    # SP.redirect redirect

            else
                if S('address').list is null or not S('address').list.length
                    data.is_default = 1
                webapi.address.create(data).then (res) =>
                    # console.log res
                    SP.message
                        msg: '新地址保存成功'
                    @getAction().saveCallback type, res

        saveCallback: (type, res) ->
            switch type
                when "checkout"
                    redirect = "/checkout"
                    liteFlux.store('checkout').getAction().setAddress res.data[res.data.length - 1]
                    SP.redirect redirect,true
                when "exchange"
                    redirect = "/exchange/checkout"
                    liteFlux.store('checkout').getAction().setAddress res.data[res.data.length - 1]
                    SP.redirect redirect,true
                when "profile"
                    redirect = "/member/address"
                    SP.back()
            @getAction().reset()



        onChange: (value, type) ->
            data = {}
            data[type] = value
            @setStore data
            validatorData.valid(type) # if type isnt 'is_default'

        setCurrent: (data) ->
            if data isnt null
                region =
                    province: data.province_id
                    province_name: data.province_name
                    city: data.city_id
                    city_name: data.city_name
                    district: data.district_id
                    district_name: data.district_name
                liteFlux.action('region').initRegion region


            @setStore
                current: data
                address: data.address
                consignee: data.consignee
                mobile: data.mobile
                second_mobile: data.second_mobile
                email: data.email
                is_default: data.is_default

        saveForLiteAddress: (callback) ->

            store = @getStore()
            region = liteFlux.store('region').getStore()
            data =
                address: store.address
                consignee: store.consignee
                mobile: store.mobile
                second_mobile: store.second_mobile
                email: store.email
                province_id: region.province
                province_name: region.province_name
                city_id: region.city
                city_name: region.city_name
                district_id: region.district
                district_name: region.district_name

            if store.current isnt null and store.current.id
                data.id = store.current.id
                # 后端要求更新的时候 回传 status
                data.status = store.status || 0
                webapi.address.update(data).then (res) =>
                    # console.log res
                    callback(data.id) if callback and typeof callback is 'function'
                    SP.message
                        msg: '地址修改成功'

                    @getAction().reset()

            else
                if S('address').list is null or not S('address').list.length
                    data.is_default = 1
                webapi.address.create(data).then (res) =>
                    # console.log
                    callback(res.data[res.data.length-1].id) if callback and typeof callback is 'function'
                    SP.message
                        msg: '新地址保存成功'

                    @getAction().reset()

        checkAndSaveForLiteAddress: (callback) ->
            addressValid = @getAction().valid()
            regionValid = A('region').valid()
            if addressValid && regionValid
                @getAction().saveForLiteAddress(callback)
            else
                SP.message
                    msg: "请检查填写信息是否正确"






Validator = liteFlux.validator
validatorData = Validator store,{
    'address':
        required: true
        minLength: 4
        maxLength: 50
        message:
            required: "地址不能为空"
            minLength: "地址不能少于4个字符"
            maxLength: "地址不能多于50个字符"
    'consignee':
        required: true
        minLength: 2
        maxLength: 10
        message:
            required: "收货人姓名不能为空"
            minLength: "收货人姓名不能少于2个字符"
            maxLength: "收货人姓名不能多于10个字符"
    'mobile':
        required: true
        phone: true
        message:
            required: "手机号码不能为空"
            phone: "请输入正确的手机号码"
},{
    #oneError: true
}

store.addAction 'valid', ->
    validatorData.valid()

module.exports = store;
