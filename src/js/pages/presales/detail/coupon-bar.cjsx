React = require 'react'
storeName = 'presales-detail'
Store = require 'stores/presales-detail'
Action = Store.getAction()

SmsNotice = require './sms-notice'
View = React.createClass

    mixins: [liteFlux.mixins.storeMixin(storeName)]
    getDefaultProps: ->
        confirmText: "我知道了"
        content: "确认?"
        margin: 30
        showCloseIcon: no
        showConfirmBtn: yes
        maskClose: no

    getInitialState: ->
        showModal: false
    onModalShow: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        @setState
            showModal: yes
    onModalHide: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        @setState
            showModal: no

    cancel:() ->
        @onModalHide()


    onTap: (e) ->
        e.preventDefault()
        e.stopPropagation()
        store = @state[storeName]
        current = store.current
        if current and current.has_bought_coupon
            SP.message
                msg: '你已经购买了优惠券'
            return null

        if @isLogin()
            @onModalShow()
            @props.onTap() if @props.onTap?
        else
            @login()

    isLogin: () ->
        isLogin = A("member").islogin()

    login: (callback, e) ->
        if typeof e isnt 'object' and typeof callback is 'object'
            e = callback
            e.stopPropagation()
            e.preventDefault()
        SP.loadLogin
           success: ->
               if callback and typeof callback is 'function'
                   callback()
               else
                   window.location.reload()

    renderModal: ->
        store = @state[storeName]
        current = store.current
        skuPicker = store.skuPicker
        sku = skuPicker.selected_sku
        <Modal name="presales-coupon-modal" title={""} onCloseClick={@cancel} show={@state.showModal} margin={10} showCloseIcon={no} maskClose={yes}>
            <div className="presales-coupon-modal">
                <h3>{current.coupon.goods_sku_price.price}元购买代金券</h3>
                <div className="presales-coupon-modal-bd">
                    <div className="presales-coupon-modal-img-box">
                        <Img src={current.thumbs.media.full_path} w={125} />
                    </div>
                    <div className="presales-coupon-modal-bd-main">
                        <div>
                            <span className="u-f14 u-color-black">代金券：</span>
                            <span className="u-f20 u-color-red">￥{current.coupon.couponTask.value}</span>
                        </div>
                        <div className="u-color-gray-summary u-mt-5">限购单品：{current.goods.title}</div>
                        <div className="u-mt-15">
                            <Link href={"/presales/guide"} className="u-color-gold u-f14">{'活动规则 >'}</Link>
                        </div>
                    </div>
                </div>
                <div className="u-text-center u-pb-10 u-pt-10 u-flex-box presales-coupon-modal-ft">
                    <div className="u-flex-item-1 u-pr-5 u-pl-15">
                        <Button onTap={@goToCheckout} large bsStyle={"primary"}>我要购券</Button>
                    </div>
                </div>
            </div>
        </Modal>
    goToCheckout: () ->
        store = @state[storeName]
        current = store.current
        A('checkout').quickbuy current.coupon_id
    render: ->
        store = @state[storeName]
        current = store.current
        if current is null
            return ''
        if current.has_bought_coupon is yes
            btn =
                <Button smaller rounded outlined bsStyle="white" disabled>已购买</Button>
        else
            btn =
                <Button smaller rounded outlined bsStyle="white" onTap={@onTap}>我要购券</Button>

        #
        # <div className="u-flex-item-1 u-text-center u-f14 u-color-black u-bg-yellow">
        #     <SmsNotice id={current.next_valid_batch_id} title="预售商品开售提醒" desc="下批销售我们将提前2个小时短信告知您">开售提醒</SmsNotice>
        # </div>
        <Toolbar>
            <div className="presales-bar u-flex-box">
                <div className="u-flex-item-2 presales-bar-coupon">
                    <div>
                        <span className="u-inline-block">￥</span>
                        <span className="u-inline-block u-f24">100</span>
                    </div>
                    <div>
                        <div className="">
                            仅
                            <span className="u-color-yellow">{current.coupon.goods_sku_price.price}</span>
                            元（限购
                            <span className="u-color-yellow">{current.goods.title}</span>
                            ）
                        </div>
                        <div className="">
                            {btn}
                            {@renderModal()}
                        </div>
                    </div>
                </div>
                <SmsNotice component="div" className="u-flex-item-1 u-text-center u-f14 u-color-black u-bg-yellow" id={current.next_valid_batch_id} title="预售商品开售提醒" desc="下批销售我们将提前2个小时短信告知您">开售提醒</SmsNotice>
            </div>
        </Toolbar>


module.exports = View
