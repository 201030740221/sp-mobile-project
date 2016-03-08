###
# Cart
# @author remiel.
# @page Cart
###
Store = appStores.cart
Action = Store.getAction()
storeName = 'cart'
CartItem = require './cart-item'
CartCollocation = require './cart-collocation'
CartEmpty = require './cart-empty'

PageView = React.createClass
    mixins: [liteFlux.mixins.storeMixin(storeName)]
    getInitialState: ->
        Action.resetUnselected()
        Action.getCart()
        {
            showModal: false
        }
    componentDidMount: ->
        # 微信分享
        shareWeixinData = S("share").shareData;
        shareWeixinData.link = location.href;  # 分享链接
        A('share').setShareData(shareWeixinData);
        # console.log @state

    componentWillUnmount: ->
        A('share').resetShareData();

    onDelete: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        Store.getAction().deleteItems()
        @onModalHide()

    onCheckout: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        Store.getAction().checkout() if @getSelectedAtLeastOneStatus()

    # getSelectedAtLeastOneStatus: ->
    #     store = @state[storeName]
    #     status = no
    #     store.items.map (item, i) =>
    #         if item.select is yes
    #             status = yes
    #     status
    #
    # getSelectedAllStatus: ->
    #     store = @state[storeName]
    #     status = yes
    #     store.items.map (item, i) =>
    #         if item.select is no
    #             status = no
    #     status

    getSelectedAtLeastOneStatus: ->
        Action.isSelectedAtLeastOne()

    getSelectedAllStatus: ->
        Action.isSelectedAll()

    onChangeSelectAll: (checked)->
        Action.selectAll checked


    list: ->
        store = @state[storeName]
        unselected = store.unselected
        node = <Loading />

        if store.items and store.items.length
            node = store.items.map (item, i) =>
                checked = not unselected[item.id]
                if item.is_multiple is no
                    <CartItem data={item} item={item.items} checked={checked} key={i}></CartItem>
                else
                    <CartCollocation data={item} checked={checked} key={i}></CartCollocation>


        else if store.items and store.items.length is 0
            node = <CartEmpty></CartEmpty>

        node

    renderBar: ->
        node = ''
        store = @state[storeName]
        unselected = store.unselected
        if store.items and store.items.length
            price = 0
            quantity = 0
            store.items.map (item, i) ->
                if not unselected[item.id]
                    price = (SP.calc.Add price, item.price, 2).toFixed 2
                    quantity += item.total_quantity || item.quantity

            selectedAtLeastOne = @getSelectedAtLeastOneStatus()
            className =
                remove: SP.classSet 'u-black-link',
                    'u-none': not selectedAtLeastOne
            node =
                <Toolbar>
                    <div className="cart-bar">
                        <Checkbox name="all" checked={@getSelectedAllStatus()} onChange={@onChangeSelectAll}>全选</Checkbox>
                        <Tappable className={className.remove} onTap={@onModalShow}>删除</Tappable>
                        <div className="cart-total">
                            <div>￥{price}</div>
                            <div>共<span className="cart-quantity">{quantity}</span>件</div>
                        </div>
                        <Button checkout className="cart-btn" onTap={@onCheckout} bsStyle='danger' disabled={if selectedAtLeastOne then no else yes}>结算</Button>
                    </div>
                </Toolbar>
        node

    renderModal: () ->
        <Modal name="cart-delete" onCloseClick={@onModalHide} showClose={false} show={@state.showModal}>
            <div className="u-text-center u-color-black u-pb-20 u-pt-30 u-f16">确认删除选中商品?</div>
            <div className="u-text-center u-pb-20">
                <Button onTap={@onDelete} bsStyle='primary' className="u-mr-20 u-black-link">删除</Button>
                <Button onTap={@onModalHide} bsStyle='primary'>取消</Button>
            </div>
        </Modal>
    onModalShow: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        @setState showModal: true
    onModalHide: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        @setState showModal: false

    render: ->
        cart = @state.cart
        List = @list()
        Bar = @renderBar()

        <Page navbar-through toolbar-through className="cart-cart">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="我的购物车"></Navbar>
            {Bar}
            <PageContent className="bg-white1">
                {List}
            </PageContent>
            {@renderModal()}
        </Page>


module.exports = PageView
