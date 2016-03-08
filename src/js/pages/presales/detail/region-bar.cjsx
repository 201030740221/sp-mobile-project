###
# RegionBar.
# @author remiel.
# @module region
###
RegionStore = require 'stores/region'
RegionAction = RegionStore.getAction()
T = React.PropTypes

constant =
    furniture: 0 # 家具
    textile: 1 # 家纺

RegionBar = React.createClass
    mixins: [liteFlux.mixins.storeMixin('region')]

    componentDidMount: ->
        if @props.sku_sn > 0
            @getDelivery()
    componentWillReceiveProps: (props) ->
        if props.sku_sn > 0 and props.sku_sn isnt @props.sku_sn
            @getDelivery()

    getDelivery: () ->
        if @props.getDelivery
            @props.getDelivery()

    callback: (value) ->
        # console.log value
        if sipinConfig.env == "production"
            liteFlux.event.emit('click99',"click", "btn_shipping_address");
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
