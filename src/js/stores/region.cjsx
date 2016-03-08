
store = liteFlux.store "region",
    data:
        data: null
        backupRegion:
            province: 6
            province_name: "广东"
            city: 76
            city_name: "广州"
            district: 696
            district_name: "海珠区"
        province: 6
        province_name: "广东"
        city: 76
        city_name: "广州"
        district: 696
        district_name: "海珠区"
        init: no
        delivery: yes

    actions:
        get: () ->
            webapi.region.get().then (res) =>
                SP.requestProxy(res).then (res)=>
                    @setStore
                        data: res.data.region

        initRegion: (region) ->
            if region and region.province and region.province_name and region.city and region.city_name and region.district and region.district_name
                @getAction().checkDelivery region.district
                data =
                    province: region.province
                    province_name: region.province_name
                    city: region.city
                    city_name: region.city_name
                    district: region.district
                    district_name: region.district_name

                SP.storage.set 'region', data
                backup = SP.assign {}, data
                data.init = yes
                data.backupRegion = backup
                @setStore data
            else if @getStore().init is no
                @setStore
                    init: yes

        getIp: () ->
            webapi.region.getIp().then (res) =>
                if res and res.code is 0
                    region = res.data
                    data =
                        province: region.province.id
                        province_name: region.province.name
                        city: region.city.id
                        city_name: region.city.name
                        district: region.district.id
                        district_name: region.district.name
                    @getAction().initRegion data
                else
                    @getAction().initRegion null

        onChange: (type, item) ->
            o = {
                delivery: yes
            }
            o[type] = item.id
            o[type+'_name'] = item.name

            if type is 'province' and item.children.length
                item = item.children[0]
                type = 'city'
                o[type] = item.id
                o[type+'_name'] = item.name

            if type is 'city'
                item = item.children[0]
                type = 'district'
                o[type] = item.id
                o[type+'_name'] = item.name
                # if item.delivery is 0
                #     SP.message
                #         msg: '该地区不支持配送'
                #     o.delivery = no
                #     # return false

            if type is 'district'
                if item.delivery is 0
                    SP.message
                        msg: '该地区不支持配送'
                    o.delivery = no
                    # return false

            @setStore o
            validatorData.valid()

        checkDelivery: (id) ->
            store = @getStore()
            data =
                region_id: id || store.district
            webapi.address.checkDelivery(data).then (res) =>
                SP.log res
                if res and res.code is 0 and res.data isnt null
                    @setStore
                        delivery: yes
                else
                    @setStore
                        delivery: no

                validatorData.valid()

        setBackupRegion: (region) ->
            data =
                province: region.province
                province_name: region.province_name
                city: region.city
                city_name: region.city_name
                district: region.district
                district_name: region.district_name

            @setStore
                backupRegion: data


Validator = liteFlux.validator
validatorData = Validator store,{
    'delivery':
        delivery: yes
        message:
            delivery: "该地区不支持配送"
},{
    #oneError: true
}
validatorData.rule 'delivery', (val)->
    val is true

store.addAction 'valid', ->
    validatorData.valid()



module.exports = store;
