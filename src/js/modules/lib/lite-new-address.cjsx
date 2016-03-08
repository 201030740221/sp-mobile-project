###
# PageNewAddress.
# @author remiel.
# @module Checkout
###
Store = require 'stores/new-address'
Action = Store.getAction()
RegionStore = require 'stores/region'
RegionAction = RegionStore.getAction()
LinkedStateMixin = require('react/lib/LinkedStateMixin')
T = React.PropTypes

PageAddress = React.createClass
    mixins: [LinkedStateMixin, liteFlux.mixins.storeMixin('newAddress', 'region')]

    getInitialState: ->

        # region =
        #     province: 32
        #     province_name: "重庆"
        #     city: 3325
        #     city_name: "合川区"
        # A('region').initRegion region

        showRegion: no
        test: ''

    componentDidMount: ->
        # console.log 'cdm'
        # console.log @state
        # if !@props.edit
        #     Action.reset()


    componentWillUnmount: ->
        Action.reset()

    onShowRegion: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
            e.target.blur()
        @setState
            showRegion: yes

    onHideRegion: () ->
        @setState
            showRegion: no

    onLinkChange: (type, value) ->
        Action.onChange value, type

    # onDefaultChange: (value) ->
    #     val = if value then 1 else 0
    #     Action.onChange val, 'is_default'
    #
    #     <Panel>
    #         <Checkbox checked={if @state.newAddress.is_default then yes else no} onChange={@onDefaultChange}>设为默认收货地址</Checkbox>
    #     </Panel>
    #
    # saveForLottery: (e) ->
    #     e.stopPropagation()
    #     e.preventDefault()
    #     addressValid = Action.valid()
    #     regionValid = RegionAction.valid()
    #     if addressValid && regionValid
    #         Action.saveForLottery()
    #     else
    #         SP.message
    #             msg: "请检查填写信息是否正确"

    render: ->
        # console.log 'render', @state
        if @state.region.init is yes
            regionLink =
                value: @state.region.province_name + " " + @state.region.city_name + " " + @state.region.district_name
        else
            regionLink = ""


        consigneeLink =
            value: @state.newAddress.consignee
            requestChange: @onLinkChange.bind null, 'consignee'
        mobileLink =
            value: @state.newAddress.mobile
            requestChange: @onLinkChange.bind null, 'mobile'
        addressLink =
            value: @state.newAddress.address
            requestChange: @onLinkChange.bind null, 'address'
        error = @state.newAddress.fieldError
        regionError = @state.region.fieldError

        title = if @props.edit then "修改地址" else "使用新地址"

        <div className="new-address">
            <div className="new-address">
                <div className="form u-mt-50">
                    <Panel>
                        <div>
                            <Input type="text" valueLink={consigneeLink}  placeholder="收货人姓名" />
                        </div>
                        <div className="form-error-info u-mt-10">{ if error and error.consignee then error.consignee[0] else ""}</div>
                    </Panel>
                    <Panel>
                        <div className="u-pr region-box">
                            <Input type="text" valueLink={regionLink} callback={@callback} onFocus={@onShowRegion} placeholder="省 / 市 / 区（县）"/>
                            <Button bsStyle="icon" icon="arrowdownlarge" onTap={@onShowRegion}/>
                        </div>
                        <div className="form-error-info u-mt-10">{ if regionError and regionError.delivery then regionError.delivery[0] else ""}</div>
                    </Panel>
                    <Panel>
                        <div>
                            <Input type="text" valueLink={addressLink}  placeholder="详细地址" />
                        </div>
                        <div className="form-error-info u-mt-10">{ if error and error.address then error.address[0] else ""}</div>
                    </Panel>
                    <Panel>
                        <div>
                            <Input type="text" valueLink={mobileLink}  placeholder="手机号码" />
                        </div>
                        <div className="form-error-info u-mt-10">{ if error and error.mobile then error.mobile[0] else ""}</div>
                    </Panel>
                </div>
            </div>
            <RegionPicker show={@state.showRegion} hide={@onHideRegion}></RegionPicker>
        </div>


    renderRegionPickerModal: () ->
        <Modal name="delivery" onCloseClick={@onModalHide} showClose={false} show={@state.delivery}>
            <DatePicker onChange={@onChange} onCancel={@onModalHide} selected={@state.deliveryDate || null}/>
        </Modal>

module.exports = PageAddress
