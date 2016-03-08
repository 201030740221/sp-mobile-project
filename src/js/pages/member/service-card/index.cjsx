###
# ServiceCard.
# @author remiel.
# @page Coupon
###
Store = appStores.serviceCard
Action = Store.getAction()
CheckoutStore = appStores.checkout
CheckoutAction = CheckoutStore.getAction()
T = React.PropTypes
ServiceCard = React.createClass
    mixins: [MemberCheckLoginMixin, liteFlux.mixins.storeMixin('service-card')]

    # 如果未登录
    _logoutCallback: ->
        SP.redirect('/member',true);

    getInitialState: ->
        if @props.type is 'checkout'
            checkout = CheckoutStore.getStore()
            if checkout.data isnt null and checkout.data.price? and checkout.data.price.total_price
                Action.getCoupon('checkout')
                Action.reset
                    keyMap: ['usable', 'unusable']
                    type: 'usable'
            else
                SP.redirect '/checkout'
        else
            Action.getCoupon()
            Action.reset
                keyMap: ['unused', 'used', 'outdated']
                type: 'unused'

        {}

    onChangeType: (type) ->
        Action.onChange type, "type"

    onSelect: (item) ->
        if @props.type is 'checkout' and @state['service-card'].type is 'usable'
            checkoutServiceCard = S('checkout').service_card
            if checkoutServiceCard and checkoutServiceCard.id is item.id
                @cancelCheckoutCoupon()
            else
                @setCheckoutCoupon item

    setCheckoutCoupon: (item) ->
        CheckoutAction.onChange item, 'service_card'

    cancelCheckoutCoupon: () ->
        CheckoutAction.onChange null, 'service_card'
        # CheckoutAction.onChange no, 'point_state'

    goToCheckout: () ->
        SP.redirect '/checkout'


    renderBar: () ->
        if @state['service-card'].type is 'usable'
            <Toolbar>
                <div className="coupon-bar u-text-center">
                    <Button large bsStyle='primary' onTap={@goToCheckout}>确定</Button>
                </div>
            </Toolbar>

    renderHeader: () ->
        coupon = @state['service-card']
        type = coupon.type
        node =
            coupon.keyMap.map (item, i) =>
                classes = "u-flex-item-1 u-black-link"
                classes += ' active' if item is type
                <Tappable component="div" className={classes} onTap={@onChangeType.bind null, item} key={i}>{coupon.valueMap[item]}</Tappable>
        <header className="coupon-hd u-flex-box u-f14">
            {node}
        </header>


    renderList: () ->
        coupon = @state['service-card']
        type = coupon.type

        if coupon.list is null
            return <Loading />

        data = coupon.list[type]
        if !data.length
            return <Empty texts={['该栏目没有会员权益卡信息']}/>

        node = data.map (item, i) =>
            task = item.task
            discount_type = task.discount_type
            switch +discount_type
                when 2
                    valueNode =
                        <div className="coupon-item-value">
                            <span className="u-f18">免费安装1次</span>
                        </div>
                    typeText = '安装服务卡'
                when 3
                    valueNode =
                        <div className="coupon-item-value">
                            <span className="u-f18">免费退货1次</span>
                        </div>
                    typeText = '退货保障卡'

            switch task.requirement
                when 0
                    text = ''
                when 1
                    text = '（满' + task.threshold + '元使用）'
            classes = "coupon-item " + type
            if @props.type is 'checkout' and CheckoutStore.getStore().service_card
                classes += " active" if type is 'usable' and item.id is CheckoutStore.getStore().service_card.id
            <div className="col-12-24" key={i}>
                <Tappable component={'div'} className={classes} onTap={@onSelect.bind null, item}>
                    <div className="coupon-item-bd">
                        <div className="coupon-item-bd-inner">
                            {valueNode}
                            <div className="u-f14 u-mt-5">{typeText}</div>
                            <div className="u-color-gray-summary">{text}</div>
                        </div>
                    </div>
                    <footer>有效期至：{item.valid_time_end_at.split(' ')[0]}</footer>
                </Tappable>
            </div>

        <div className="coupon-list grid">
            {node}
        </div>

    render: ->
        coupon = @state['service-card']
        if coupon.type is 'outdated' and coupon.list['outdated'].length
            outdatedInfo = <div className="u-text-center u-color-gray-summary u-mt-15">- 仅显示最近30天过期的会员权益卡 -</div>
        <Page navbar-through toolbar-through className="member-coupon">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="会员权益卡"></Navbar>
            {@renderBar()}
            <PageContent>
                {@renderHeader()}
                {outdatedInfo}
                {@renderList()}
            </PageContent>
        </Page>


module.exports = ServiceCard
