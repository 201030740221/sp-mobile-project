###
# Coupon.
# @author remiel.
# @page Coupon
###
Store = appStores.coupon
Action = Store.getAction()
CheckoutStore = appStores.checkout
CheckoutAction = CheckoutStore.getAction()
T = React.PropTypes
Coupon = React.createClass
    mixins: [MemberCheckLoginMixin, liteFlux.mixins.storeMixin('coupon')]

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
    confirmCode: () ->
        Action.activateCoupon(@props.type)

    handleCodeChange: (value) ->
        Action.onChange value, 'code'


    onChangeType: (type) ->
        Action.onChange type, "type"

    onSelect: (item) ->
        if @props.type is 'checkout' and @state.coupon.type is 'usable'
            if +S('checkout').coupon_ids is item.id
                @cancelCheckoutCoupon()
            else
                @setCheckoutCoupon item

    setCheckoutCoupon: (item) ->
        CheckoutAction.onChange item.id, 'coupon_ids'
        switch item.task.discount_type
            when 0
                CheckoutAction.onChange item.task.value + '元', 'coupon_text'
            when 1
                CheckoutAction.onChange (SP.calc.Mul +item.task.value, 10) + '折', 'coupon_text'

    cancelCheckoutCoupon: () ->
        CheckoutAction.onChange '', 'coupon_ids'
        CheckoutAction.onChange '', 'coupon_text'
        # CheckoutAction.onChange no, 'point_state'

    goToCheckout: () ->
        SP.redirect '/checkout'


    renderBar: () ->
        if @state.coupon.type is 'usable'
            <Toolbar>
                <div className="coupon-bar u-text-center">
                    <Button large bsStyle='primary' onTap={@goToCheckout}>确定</Button>
                </div>
            </Toolbar>

    renderHeader: () ->
        coupon = @state.coupon
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
        coupon = @state.coupon
        type = coupon.type

        if coupon.list is null
            return <Loading />

        data = coupon.list[type]
        if !data.length
            return <Empty texts={['该栏目没有优惠券信息']}/>

        node = data.map (item, i) =>
            task = item.task
            discount_type = task.discount_type
            switch +discount_type
                when 0
                    valueNode =
                        <div className="coupon-item-value">
                            <span className="u-f20">￥</span>
                            <span className="u-f24">{SP.calc.Add item.task.value, 0}</span>
                        </div>
                    typeText = '满减券'
                when 1
                    valueNode =
                        <div className="coupon-item-value">
                            <span className="u-f24">{SP.calc.Mul +item.task.value, 10}</span>
                            <span className="u-f20">折</span>
                        </div>
                    typeText = '折扣券'

            switch task.requirement
                when 0
                    text = '（无限制）'
                when 1
                    text = '（满' + task.threshold + '元）'
            classes = "coupon-item " + type
            if @props.type is 'checkout'
                classes += " active" if type is 'usable' and item.id is +CheckoutStore.getStore().coupon_ids
            <div className="col-12-24" key={i}>
                <Tappable component={'div'} className={classes} onTap={@onSelect.bind null, item}>
                    <div className="coupon-item-bd">
                        <div className="coupon-item-bd-inner">
                            {valueNode}
                            <div>券号：{item.id}</div>
                            <div className="u-color-gray-summary">{text}</div>
                            <div className="u-mt-10">
                                <Button outline rounded smaller bsStyle="red">{typeText}</Button>
                            </div>
                        </div>
                    </div>
                    <footer>
                        <div>有效期</div>
                        <div>
                            {item.valid_time_start_at.split(' ')[0].replace('-','.')}
                            {' ~ '}
                            {item.valid_time_end_at.split(' ')[0].replace('-','.')}
                        </div>
                    </footer>
                </Tappable>
            </div>

        <div className="coupon-list grid">
            {node}
        </div>

    renderExchangeModal: () ->
        coupon = @state.coupon
        error = coupon.fieldError
        code =
            value: coupon.code
            requestChange: @handleCodeChange
        <div className="form">
            <Panel>
                <div>
                    <Input type="text" valueLink={code} placeholder="请输入折扣码" />
                </div>
                <div className="form-error-info u-mt-10">{ if error and error.code then error.code[0] else ""}</div>
            </Panel>
        </div>


    render: ->
        coupon = @state.coupon
        if coupon.type is 'outdated' and coupon.list['outdated'].length
            outdatedInfo = <div className="u-text-center u-color-gray-summary u-mt-15">- 仅显示最近30天过期的优惠券 -</div>
        if coupon.type is 'unused' or coupon.type is 'usable'
            activeCoupon =
                <div className="u-text-center u-mt-15">
                    {"有折扣码? "}
                    <Confirmable className="u-color-gold" title="激活折扣码" contentElement={@renderExchangeModal()} confirm={@confirmCode}>现在兑换</Confirmable>
                </div>
        <Page navbar-through toolbar-through className="member-coupon">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="我的优惠券"></Navbar>
            {@renderBar()}
            <PageContent>
                {@renderHeader()}
                {outdatedInfo}
                {activeCoupon}
                {@renderList()}
            </PageContent>
        </Page>


module.exports = Coupon
