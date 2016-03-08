###
# Payment
# @author remiel.
# @page Payment
###
Store = appStores.payment
Action = Store.getAction()
PageView = React.createClass
    mixins: [MemberCheckLoginMixin, liteFlux.mixins.storeMixin('payment')]
    getInitialState: ->
        Action.init @props.id
        {}

    componentWillReceiveProps: (nextProps) ->
        Action.init nextProps.id

    componentDidMount: ->
        if SP.isWeixinBrowser()
            @setPaymentMethod 2

    componentWillUnmount: ->
        Action.reset()

    setPaymentMethod: (id) ->
        Action.setPaymentMethod id

    getPaymentBtn: ->
        if SP.isWeixinBrowser()
            return (
                <Tappable component="div" className="form-box-bd has-padding-top has-border-bottom border-dashed payment-method" onTap={@setPaymentMethod.bind null, 2}>
                    <span className="payment-method-icon wxpay"></span>
                    <span className="u-color-gray-summary">微信支付</span>
                    <Button bsStyle="icon" icon='select' className={if @state.payment.partner_id is 2 then "form-box-icon active" else "form-box-icon"}/>
                </Tappable>
            )
        else
            return (
                <Tappable component="div" className="form-box-bd has-padding-top has-border-bottom border-dashed payment-method" onTap={@setPaymentMethod.bind null, 1}>
                    <span className="payment-method-icon alipay"></span>
                    <span className="u-color-gray-summary">支付宝支付</span>
                    <Button bsStyle="icon" icon='select' className={if @state.payment.partner_id is 1 then "form-box-icon active" else "form-box-icon"}/>
                </Tappable>
            )

    weixinPay: ->
        # 微信支付
        if SP.getWeixinVersion() >= 5
            order = @state.payment.order
            partner_id = @state.payment.partner_id
            href = "#{order.pay_url}?order_id=#{@props.id}&partner_id=#{partner_id}"

            location.href = href
        else
            SP.message
                msg: '请升级微信到最新版'

    renderBar: () ->
        order = @state.payment.order.detail
        order.pay_url = @state.payment.order.pay_url

        price = order.total
        if order.type is 1
            switch order.presale_status
                when 0 then price = order.earnest_money
                when 1 then price = order.balance_due

        isAlipay = @state.payment.partner_id is 1
        isWeixinPay = @state.payment.partner_id is 2

        if isAlipay
            checkoutBtn = <Button component="a" href={order.pay_url + "?order_no=" + order.order_no + "&partner_id=" + @state.payment.partner_id} checkout className="checkout-btn" bsStyle='danger'>确认支付</Button>

        if isWeixinPay
            checkoutBtn = <Tappable component="a" onTap={this.weixinPay}><Button checkout className="checkout-btn" bsStyle='danger'>确认支付</Button></Tappable>

        if order isnt null and order.order_no?
            <Toolbar>
                <div className="checkout-bar">
                    <div className="checkout-bar-total">
                        <span className="u-color-gray-summary">应付金额：</span>
                        <span className="u-color-blackred u-f16">￥{price}</span>
                    </div>

                    {checkoutBtn}
                </div>
            </Toolbar>

    render: ()->
        order = @state.payment.order

        if order is null
            return <Loading />

        order = order.detail

        if !order.order_no?
            SP.message
                msg: '订单不存在'
            SP.redirect '/member/order/all'

        if order.status_id isnt 1
            SP.message
                msg: '该订单不是等待付款状态'
            SP.redirect '/member/order/all'

        address = order.delivery.member_address

        if order.is_flashsale_order is 1
            time = "15分钟内"
        else
            time = "48小时内"

        title = '订单支付'
        orderText1 = '订单信息'
        orderText2 = "您的订单已提交成功，订单号为#{order.order_no} ，感谢您的订购！"
        orderText3 = '订单将会自动取消'

        if order.type is 1
            switch order.presale_status
                when 0
                    title = '定金支付'
                    time = '20分钟内'
                    orderText1 = '完成定金支付'
                when 1
                    title = '尾款支付'
                    time = order.presale.presaleBatch.pay_deadline + '前'
                    orderText1 = '完成尾款支付'
                    orderText2 = "您已成功支付了预售商品#{order.goods_title}所需的定金¥#{order.earnest_money},尚需支付尾款¥#{order.balance_due}"
                    orderText3 = '将造成延后发货'

        <Page navbar-through toolbar-through className="payment-payment">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title={title}></Navbar>
            {@renderBar()}
            <PageContent>
                <div className="form-box u-mb-10">
                    <header className="form-box-hd large-padding has-border-bottom">
                        {orderText1}
                    </header>
                    <div className="form-box-bd has-padding-top has-border-bottom border-dashed">
                        <div className="u-mb-5 u-word-break-all">
                            {orderText2}
                        </div>
                        <div className="u-color-gray-summary">
                            请在{time}完成{title}，否则{orderText3}
                        </div>
                    </div>
                    <div className="form-box-bd has-padding-top">
                        <div className="u-mb-5">
                            收货信息
                        </div>
                        <div className="u-color-gray-summary">
                            <span>{address.consignee}</span>{' '}
                            <span>{address.mobile}</span>
                        </div>
                        <div className="u-color-gray-summary u-word-break-all">{address.province_name}{' '}{address.city_name}{' '}{address.district_name}{' '}{address.address}</div>
                    </div>
                </div>

                <div className="form-box paymengt-method">
                    <header className="form-box-hd large-padding has-border-bottom">
                        支付方式
                    </header>

                    {this.getPaymentBtn()}

                    <div className="u-pt-30"></div>
                </div>
            </PageContent>
        </Page>


module.exports = PageView
