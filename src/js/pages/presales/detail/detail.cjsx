React = require 'react'
moment = require 'moment'
require 'stores/presales-home'
storeName = 'presales-detail'
Store = require 'stores/presales-detail'
Action = Store.getAction()

CouponBar = require './coupon-bar'
BookingBar = require './booking'
SmsNotice = require './sms-notice'
GoToSkuDetail = require './go-to-sku-detail'

BarMixins = require './bar-mixins'
PageView = React.createClass
    storeName: storeName
    mixins: [liteFlux.mixins.storeMixin(storeName), BarMixins]
    getInitialState: ->
        @init @props
    componentWillReceiveProps: (props) ->
        Action.onSetStore @init props

    init: (props) ->
        A('presales-home').reset()
        Action.reset()
        Action.getPresales props.id
        id: props.id


    renderSlider: () ->
        store = @state[storeName]
        server_time = store.server_time
        current = store.current
        list = current.mobileContents
        if list and list.length
            nodes = current.mobileContents.map (item, i) =>
                <Img src={item.media.full_path} w={640} key={i}/>
                style =
                    "backgroundImage": "url(#{item.media.full_path})"
                <div className="presales-detail-img-box" style={style} key={i}></div>
            <SliderVertical preventDefault>
                {nodes}
            </SliderVertical>
        else
            ''

    render: ->

        store = @state[storeName]
        server_time = store.server_time
        current = store.current
        if not current
            return <Loading />

        <Page navbar-through toolbar-through className="presales-detail">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="详情"></Navbar>
            {@renderBar()}
            <PageContent>
                <div className="presales-slider">
                    {@renderSlider()}
                </div>
                <div icon="back" className="icon icon-back presales-up-icon"></div>
            </PageContent>
        </Page>
module.exports = PageView
