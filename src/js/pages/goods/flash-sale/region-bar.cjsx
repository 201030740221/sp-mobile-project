###
# RegionBar.
# @author remiel.
# @module region
###
GoodsDeatilStore = appStores.flashSale
GoodsDeatilAction = GoodsDeatilStore.getAction()
RegionStore = appStores.region
RegionAction = RegionStore.getAction()
LinkedStateMixin = require('react/lib/LinkedStateMixin')
T = React.PropTypes

RegionBar = React.createClass
    mixins: [liteFlux.mixins.storeMixin('region')]

    componentDidMount: ->
        if @props.sku_sn > 0
            @getDelivery()
    componentWillReceiveProps: (props) ->
        if props.sku_sn > 0 and props.sku_sn isnt @props.sku_sn
            @getDelivery()

    getDelivery: () ->
        GoodsDeatilAction.getDelivery()

    callback: (value) ->
        # console.log value
        @getDelivery()

    render: ->
        # console.log 'render', @state
        region = @state.region

        regionError = @state.region.fieldError

        <Grid cols={24} className="label-list">
            <Col span={5} className="label-title">配送至:</Col>
            <Col span={18} className="title-content address-picker-name">
                <RegionView callback={@callback} style={{paddingLeft:'20'}}/>
            </Col>
        </Grid>

module.exports = RegionBar
