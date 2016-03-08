###
# Checkout
# @author remiel.
# @page Cart/Checkout
###
Store = appStores.checkout
Action = Store.getAction()
AddressStore = appStores.address
AddressAction = AddressStore.getAction()

SmsSetting = require './sms-setting'
Address = require './address'
Date = require './date'
Goods = require './goods'
Point = require './point'
Coupon = require './coupon'
Invoice = require './invoice'
Note = require './note'
Total = require './total'
ServiceCard = require './service-card'
moment = require 'moment'

PageView = React.createClass

    mixins: [MemberCheckLoginMixin, liteFlux.mixins.storeMixin('checkout')]

    getInitialState: ->
        if Store.getStore().address is null
            AddressAction.getAddress()
        A('point').getPoint()
        {}

    componentDidMount: ->
        Action.init()
        checkout = @state.checkout
        if @state.checkout.data is null
            SP.redirect '/cart'

        # Action.autoGetCheckoutPrice() if checkout.address isnt null
        # if checkout.address isnt null and checkout.member_address_id isnt ''
        #     region_id = checkout.address.district_id
        #     data =
        #         region_id: region_id
        #     if checkout.coupon_ids
        #         data.coupon_ids = checkout.coupon_ids
        #     if checkout.point_state and checkout.available_point > 0
        #         total = SP.calc.Mul checkout.data.price.total, 100
        #         total = checkout.available_point if total > checkout.available_point
        #         data.point = total
        #     Action.getCheckoutPrice data
    onSubmit: (e) ->
        e.preventDefault()
        e.stopPropagation()
        Action.submit()

    onSelected: (checked) ->
        Action.onCheckbox checked


    renderBar: (data) ->
        node =
            <div className="checkout-bar-total">
                <span className="u-color-gray-summary">总计：</span>
                <span className="u-color-blackred u-f16">￥{data.price.total}</span>
            </div>

        if data.presale is 1
            checked = @state.checkout.earnest_money_pay_agree
            node =
                <div className="checkout-bar-total">
                    <Checkbox checked={checked} onChange={@onSelected}>同意支付定金</Checkbox>
                </div>

        <Toolbar>
            <div className="checkout-bar">
                {node}
                <Button checkout className="checkout-btn" onTap={@onSubmit} bsStyle='danger' disabled={if yes then no else yes}>提交</Button>
            </div>
        </Toolbar>

    render: ->
        data = @state.checkout.data

        if data is null
            return <Loading />

        totalData = data.price
        # 预售商品尾款通知
        if data.presale is 1
            smsNode = then <SmsSetting data={data.presale_batch_skus.presaleBatch.pay_deadline} />
            totalData.type = 1
            totalData.presale_status = 0
            totalData.earnest_money = data.presale_batch_skus.earnest_money
        else
            smsNode = null

        if !data.flash_sale_id and data.exchange isnt 1 and moment('2015-11-29 00:00:00').isBefore()
            pointNode =
                <Point data={@state.checkout}/>

        if !data.flash_sale_id and data.exchange isnt 1
            couponNode =
                <Coupon data={@state.checkout.coupon_text}/>

        if !data.flash_sale_id and data.exchange isnt 1
            serviceCardNode =
                <ServiceCard data={@state.checkout.service_card}/>

        if !data.flash_sale_id and data.exchange isnt 1
            invoiceNode =
                <Invoice data={@state.checkout.invoice_text}/>

        if data.is_show_datepicker
            datePickerNode =
                <Date delivery={data.shipping_date.start.split(' ')[0]} install={data.shipping_date.start.split(' ')[0]} end={@state.checkout.last_date} reserveInstallationTime={@state.checkout.reserve_installation_time} reserveDeliveryTime={@state.checkout.reserve_delivery_time}/>

        note = <Note />

        if !!data.virtual_goods_only # 虚拟商品，如优惠券
            datePickerNode = null
            couponNode = null
            serviceCardNode = null
            invoiceNode = null
            note = null

        if data.presale is 1 # 支付定金的情况
            pointNode = null

        <Page navbar-through toolbar-through className="cart-checkout">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="订单确认"></Navbar>
            {@renderBar(data)}
            <PageContent className="checkout-main">
                {smsNode}
                <Address data={@state.checkout.address} type="checkout"/>
                {datePickerNode}
                <Goods data={data}/>
                {pointNode}
                {couponNode}
                {serviceCardNode}
                {invoiceNode}
                {note}
                <Total flashsale={!!data.flash_sale_id} data={totalData} showGetPoint={yes} showTotal={!!data.presale}/>
            </PageContent>
        </Page>


module.exports = PageView
