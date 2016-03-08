###
# RegionPicker.
# @author remiel.
# @module RegionPicker
# @example RegionPicker
#
#   jsx:
#   <RegionPicker></RegionPicker>
#
# @param options {Object} the options
# @option xx {String}
#
###

Store = require 'stores/region'
Action = Store.getAction()
T = React.PropTypes

RegionPicker = React.createClass
    mixins: [liteFlux.mixins.storeMixin('region')]

    propsType:
        # province: T.number
        # province_name: T.string
        # city: T.number
        # city_name: T.string
        # district: T.number
        # district_name: T.string
        region: T.object
        callback: T.func
        hide: T.func

    getDefaultProps: ->
        # province: 6
        # province_name: "广东"
        # city: 76
        # city_name: "广州"
        # district: 696
        # district_name: "海珠区"
        callback: (value) ->
            SP.log 'callback ',value

    getInitialState: ->
        Action.get()
        if @props.region
            Action.initRegion @props.region
        else if SP.storage.get('region') isnt null
            Action.initRegion SP.storage.get 'region'
        else
            Action.getIp()
        {}


    componentDidMount: ->

    onModalHide: () ->
        @props.hide()

    onChange: (type, item) ->
        Action.onChange type, item


    render: ->
        # console.log 'render ',@state.region
        if !(@state.region and @state.region.data?)
            return <span></span>

        activeProvince = 0
        activeCity = 0
        activeDistrict = 0

        provinces = []
        citys = []
        districts = []

        provinces = @state.region.data || []
        if provinces.length
            citys = provinces[0].children
            provinces.map (item, i) =>
                if @state.region.province is item.id
                    activeProvince = i
                    citys = item.children
            districts = citys[0].children
            citys.map (item, i) =>
                if @state.region.city is item.id
                    activeCity = i
                    districts = item.children
            districts.map (item, i) =>
                if @state.region.district is item.id
                    activeDistrict = i

        <Modal name="RegionPicker" onCloseClick={@onModalHide} show={@props.show}>
            <div className="Region-picker">
                <div className="lite-modal-hd">
                    请选择配送地区
                </div>
                <div className="u-flex-box">
                    <div className="u-flex-item-1">
                        <TouchSelector data={provinces} textKey="name" onChange={@onChange.bind null,'province'} active={activeProvince || 0}></TouchSelector>
                    </div>
                    {if citys and citys.length
                        <div className="u-flex-item-1">
                            <TouchSelector data={citys} textKey="name" onChange={@onChange.bind null,'city'} active={activeCity || 0}></TouchSelector>
                        </div>
                    }
                    {if districts and districts.length
                        <div className="u-flex-item-1">
                            <TouchSelector data={districts} textKey="name" onChange={@onChange.bind null,'district'} active={activeDistrict || 0}></TouchSelector>
                        </div>
                    }
                </div>

                <div className="u-flex-box u-pl-15 u-pr-15 u-pb-10">
                    <div className="u-flex-item-1 u-pr-5">
                        <Button block bsStyle='primary' onTap={@cancel}>取消</Button>
                    </div>
                    <div className="u-flex-item-1 u-pl-5">
                        <Button block disabled={!@state.region.delivery} bsStyle='primary' onTap={@ok}>确定</Button>
                    </div>
                </div>
            </div>
        </Modal>


    ok: (e) ->
        e.stopPropagation()
        e.preventDefault()
        if Action.valid()
            region = @state.region
            data =
                province: region.province
                province_name: region.province_name
                city: region.city
                city_name: region.city_name
                district: region.district
                district_name: region.district_name


            SP.storage.set 'region', data
            Action.setBackupRegion data
            @props.callback data
            @props.hide()
        else
            SP.message
                msg: '该地区不支持配送'

    cancel: (e) ->
        e.stopPropagation()
        e.preventDefault()
        @props.hide()
        # if !Action.valid()
        data = @state.region.backupRegion
        Action.initRegion data





module.exports = RegionPicker
