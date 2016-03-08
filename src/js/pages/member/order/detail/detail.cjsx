###
# Checkout
# @author remiel.
# @page Cart/Checkout
###
pageStore = 'order-detail';

# Goods = require 'pages/cart/checkout/goods'
Total = require 'pages/cart/checkout/total'

Goods = React.createClass
    render: ->
        <CheckoutGoods className="u-mb-10" data={@props.data}>
            <header className="form-box-hd has-border-bottom no-margin-sides has-padding-sides">
                商品清单
            </header>
        </CheckoutGoods>

PageView = React.createClass

    mixins: [liteFlux.mixins.storeMixin(pageStore),MemberCheckLoginMixin]

    # 如果未登录
    _logoutCallback: ->
        SP.redirect('/member',true);

    getInitialState: ->
        {}
    componentDidMount: ->
        A("order-detail").init(@props.id)
    componentWillReceiveProps: (nextProps)->
        A("order-detail").init(nextProps.id)
    componentWillUnmount: ->
        liteFlux.store(pageStore).reset();
    onPay: ->
        SP.redirect '/payment/'+@state['order-detail'].detail.order_no
    onCancel: ->
        self = this
        webapi.order.cancelOrder({
            order_no: @state['order-detail'].detail.order_no,
            reason_id: 0
        }).then (res)->
            if res and res.code == 0
                A("order-detail").init(self.props.id)
                SP.message
                    msg: "取消订单成功"
                    callback: ->
            else
                SP.message
                    msg: "取消订单失败"
                    callback: ->
    onRemove: ->
        self = this
        webapi.order.deleteOrder({
            order_no: @state['order-detail'].detail.order_no
        }).then (res)->
            if res and res.code == 0
                SP.message
                    msg: "删除订单成功"
                    callback: ->
                        SP.back()
            else
                SP.message
                    msg: "删除订单失败"
                    callback: ->
    renderBar: (data) ->
        state = @state
        detail = @state[pageStore].detail
        status_id = detail.status_id
        state[pageStore].toolThrough = true
        spans = 24
        switch status_id
            when 1
                spans = 12
            when 2
                state[pageStore].toolThrough = false
            when 3
                state[pageStore].toolThrough = false
        S(pageStore,state)

        payBtnText = '付款'
        if detail.type is 1
            payBtnText = switch
                when detail.presale_status is 0 then '支付定金'
                when detail.presale_status is 1 then '支付尾款'

        # 预售订单已支付定金或普通订单已支付成功不能取消订单
        # if (status_id is 1) or (status_id is 2)
        #     cancelCls = 'order-detail-toolbar-btn'
        # else
        #     cancelCls = 'u-none'
        #
        # if detail.presale_status and detail.presale_status isnt 0
        #     cancelCls = 'u-none'

        if (detail.type is 0 and status_id < 4) or (detail.type is 1 and detail.presale_status is 0)
            cancelCls = 'order-detail-toolbar-btn'
        else
            cancelCls = 'u-none'

        node =
            <Toolbar className="order-detail-toolbar">
                <Grid cols={24}>
                    <Col span={spans} className={if (status_id==6||status_id==5) then "order-detail-toolbar-btn" else "u-none"}>
                        <Button block onTap={@onRemove} bsStyle='primary'>删除订单</Button>
                    </Col>
                    <Col span={spans} className={cancelCls}>
                        <Button block onTap={@onCancel} bsStyle='primary'>取消订单</Button>
                    </Col>
                    {#<Col span={spans} className={if status_id==5 then "order-detail-toolbar-btn" else "u-none"}><Button block onTap={@onSubmit} bsStyle='primary'>申请退换货</Button></Col>}
                    <Col span={spans} className={if status_id==1 then "order-detail-toolbar-btn" else "u-none"}>
                        <Button block onTap={@onPay} bsStyle='danger'>{payBtnText}</Button>
                    </Col>
                </Grid>
            </Toolbar>
        node

    render: ->
        if !@state[pageStore].detail.goods.length
            <Page navbar-through toolbar-through className="cart-checkout">
                <Navbar leftNavbar={<BackButton />} title="订单详情"></Navbar>
                <Loading />
                <PageContent className="checkout-main">
                </PageContent>
            </Page>
        else
            if @state[pageStore].detail.not_only_textile is 1
                delivery =
                    <div className="order-delivery">
                        <h3>送货时间</h3>
                        <div className="order-delivery-content">
                            <table className="order-delivery-table">
                                <tr>
                                    <td className="order-delivery-table-title u-text-right">送货时间：</td>
                                    <td>{@state[pageStore].detail.delivery.reserve_delivery_time}</td>
                                </tr>
                                <tr>
                                    <td className="order-delivery-table-title u-text-right">安装时间：</td>
                                    <td>{@state[pageStore].detail.delivery.reserve_installation_time}</td>
                                </tr>
                            </table>
                        </div>
                    </div>
            else
                delivery = ''
            <Page navbar-through toolbar-through={@state[pageStore].toolThrough} className="cart-checkout">
                <Navbar leftNavbar={<BackButton />} title="订单详情"></Navbar>
                {@renderBar()}
                <PageContent className="checkout-main">
                    <Panel className="box-item u-mb-10">

                        <Grid className="profile-order-title border-gay-dotted" cols={24}>
                            <Col span={18}>
                                <span className="u-color-gray-label">订单号：{@state[pageStore].detail.order_no}<code className="u-color-black"></code></span>
                            </Col>
                            <Col span={6} className="u-text-right">
                                <span className="u-color-gray-label">{@state[pageStore].detail.status}</span>
                            </Col>
                        </Grid>

                        <div className="order-delivery border-gay-dotted">
                            <h3>收货人信息</h3>
                            <div className="order-delivery-content">
                                <table className="order-delivery-table">
                                    <tr>
                                        <td className="order-delivery-table-title u-text-right">收&nbsp;货&nbsp;人：</td>
                                        <td>{@state[pageStore].detail.delivery.member_address.consignee}</td>
                                    </tr>
                                    <tr>
                                        <td className="order-delivery-table-title u-text-right">收货地址：</td>
                                        <td>
                                            {@state[pageStore].detail.delivery.member_address.province_name}
                                            {@state[pageStore].detail.delivery.member_address.city_name}
                                            {@state[pageStore].detail.delivery.member_address.district_name}
                                            {@state[pageStore].detail.delivery.member_address.address}
                                        </td>
                                    </tr>
                                    <tr>
                                        <td className="order-delivery-table-title u-text-right">手机号码：</td>
                                        <td>{@state[pageStore].detail.delivery.member_address.mobile}</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        {delivery}

                    </Panel>

                    <Goods data={@state[pageStore].detail.goods}/>
                    <Total data={@state[pageStore].detail} showTotal />
                </PageContent>
            </Page>


module.exports = PageView
