###
# Checkout
# @author remiel.
# @page Cart/Checkout
###
Store = appStores.checkout
Action = Store.getAction()
AddressStore = appStores.address
AddressAction = AddressStore.getAction()

Address = require './address'
Goods = require './goods'
Total = require './total'

PageView = React.createClass

    mixins: [MemberCheckLoginMixin, liteFlux.mixins.storeMixin('checkout')]

    getInitialState: ->
        if Store.getStore().address is null
            AddressAction.getAddress()
        {}

    componentDidMount: ->
        if @state.checkout.data is null
            SP.redirect '/cart'

    onSubmit: (e) ->
        e.preventDefault()
        e.stopPropagation()
        Action.submit()


    renderBar: (data) ->
        node = ''
        if yes
            node =
                <Toolbar>
                    <div className="checkout-bar">
                        <div className="checkout-bar-total">
                            <span className="u-color-gray-summary">总计：</span>
                            <span className="u-color-blackred u-f16">￥{data.price.total}</span>
                        </div>
                        <Button checkout className="checkout-btn" onTap={@onSubmit} bsStyle='danger' disabled={if yes then no else yes}>提交</Button>
                    </div>
                </Toolbar>
        node

    render: ->
        # console.log @state
        data = @state.checkout.data

        if data is null
            return <Loading />

        <Page navbar-through toolbar-through className="cart-checkout">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="订单确认"></Navbar>
            {@renderBar(data)}
            <PageContent className="checkout-main">
                <Address data={@state.checkout.address} className="u-mb-10" type="exchange"/>

                <Goods data={data.goods}/>

                <Total data={data.price}/>
            </PageContent>
        </Page>


module.exports = PageView
