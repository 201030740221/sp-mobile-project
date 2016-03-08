pageStore = "order-list";

moment = require('moment');
CountDown = require('components/lib/count-down');

CountDownContent = React.createClass
    render: ->
        <span className="u-color-black">{this.props.hours + ":" + this.props.minutes + ":" + this.props.seconds}</span>

# 单条订单
OrderItem = React.createClass
    getInitialState: ->
        {
            showHandle: false
        }
    onModalHide: ->
        state = @state;
        state.showHandle = false;
        this.setState(state);
    onViewOrderDetail: ->
        SP.redirect('/member/order/detail/'+@props.data.order_no)
    onPay: ->
        SP.redirect('/payment/'+@props.data.order_no)
    onCancel: ->
        self = this
        webapi.order.cancelOrder({
            order_no: @props.data.order_no,
            reason_id: 0
        }).then (res)->
            if res and res.code == 0
                self.props.reload(S('order-list').current_page)
                SP.message
                    msg: "取消订单成功"
                    callback: ->
                        self.onModalHide()
            else
                SP.message
                    msg: "取消订单失败"
                    callback: ->
                        self.onModalHide()
    onRemove: (orderList,index)->
        self = this
        webapi.order.deleteOrder({
            order_no: @props.data.order_no
        }).then (res)->
            if res and res.code == 0
                state = S("order-list")
                state.data = SP.removeArray(orderList,index)
                S "order-list",state
                SP.message
                    msg: "删除订单成功"
                    callback: ->
                        self.onModalHide()
            else
                SP.message
                    msg: "删除订单失败"
                    callback: ->
                        self.onModalHide()
    renderModal: ->
        return (
            <Modal maskClose={true} name="orderHanderModal" onCloseClick={@onModalHide} show={@state.showHandle}>
                <div className="orderHanderButtons">
                    <Button onTap={@onPay} className={"u-none" if @props.data.status_id!=1} bsStyle='primary' block >立即付款</Button>
                    <Button onTap={@onViewOrderDetail} bsStyle='primary' block >查看订单</Button>
                    {#<Button className={"u-none" if @props.data.status_id!=5} bsStyle='primary' block >申请退换货</Button>}
                    <Button onTap={@onCancel} className={"u-none" if @props.data.status_id!=1 or @props.data.presale_status!=0} bsStyle='primary' block >取消订单</Button>
                    <Button onTap={@onRemove.bind(null,@props.list,@props.index)} className={"u-none" if (@props.data.status_id<5)} bsStyle='primary' block >删除订单</Button>
                </div>
            </Modal>
        )
    # 更多操作
    getMoreHandle: (e)->
        e.stopPropagation()
        e.preventDefault()
        state = @state;
        state.showHandle = true;
        this.setState(state);
    componentDidMount: ->

    # 预售商品订单状态
    renderOrderStatus: ->
        data = @props.data
        presale_status = data.presale_status

        ftNode = null
        switch presale_status
            when 0 then ftNode = (
                <Grid cols={24} className="u-pt-10">
                    <Col span={18} className="u-color-gray-summary">
                        <p>定金金额：<span className="u-color-blackred">¥{data.earnest_money}</span></p>
                        <p>请在
                            <CountDown data={{
                                startTime: moment(),
                                endTime: moment(data.created_at).add(data.booking_expire, 's')
                                }}
                                component={CountDownContent} />
                         内完成支付</p>
                    </Col>
                    <Col span={6}>
                        <Button onTap={@onPay}>支付定金</Button>
                    </Col>
                </Grid>
            )
            when 1 then ftNode = (
                <Grid cols={24} className="u-pt-10">
                    <Col span={18} className="u-color-gray-summary">
                        <p>尾款金额：<span className="u-color-blackred">¥{data.balance_due}</span></p>
                        <p>请在 <span className="u-color-black">{data.pay_deadline}</span> 前完成支付</p>
                    </Col>
                    <Col span={6}>
                        <Button onTap={@onPay}>支付尾款</Button>
                    </Col>
                </Grid>
            )

        getStatusCls = (id) ->
            return if presale_status >= id then 'num active' else 'num'

        getStatusText = (id) ->
            return if presale_status >= id then <p className="active">已完成</p> else <p className="u-color-gray-summary">未完成</p>

        return (
            <div className="profile-order-status">
                <Grid cols={24}>
                    <Col span={2} className={getStatusCls(1)}><span>01</span></Col>
                    <Col span={4}>
                        <p>支付定金</p>
                        {getStatusText(1)}
                    </Col>
                    <Col span={3} className="arrow">
                        &rsaquo;&nbsp;&rsaquo;&nbsp;&rsaquo;
                    </Col>
                    <Col span={2} className={getStatusCls(2)}><span>02</span></Col>
                    <Col span={4}>
                        <p>支付尾金</p>
                        {getStatusText(2)}
                    </Col>
                    <Col span={3} className="arrow">
                        &rsaquo;&nbsp;&rsaquo;&nbsp;&rsaquo;
                    </Col>
                    <Col span={2} className={getStatusCls(3)}><span>03</span></Col>
                    <Col span={4}>
                        <p>完成订单</p>
                        {getStatusText(3)}
                    </Col>
                </Grid>
                {ftNode}
            </div>
        )

    render: ->
        return (
            <Panel className="box-item u-mb-10">
                {this.renderModal()}

                <Tappable component="div">
                <Grid className="profile-order-title border-gay-dotted" cols={24}>
                    <Col span={18}>
                        <span className="u-color-gray-label">订单号：<code className="u-color-black">{@props.data.order_no}</code></span>
                    </Col>
                    <Col span={6} className="u-text-right">
                        <span className="u-color-gray-label">{@props.data.status}</span>
                    </Col>
                </Grid>
                </Tappable>

                <Grid className="profile-order-subtitle border-gay-dotted" cols={24}>
                    <Col span={18}>
                        <span className="u-color-gray-label">订单总额：<code className="u-color-gold">￥{@props.data.total}</code></span>
                    </Col>
                    <Col span={6} className="u-text-right">
                        <Button className="order-item-more-action" onTap={@getMoreHandle} bsStyle="icon" icon="menulist" ></Button>
                    </Col>
                </Grid>

                <div className="profile-order-goods">
                    <CheckoutGoods data={@props.data.goods}></CheckoutGoods>
                </div>

                {@renderOrderStatus(@props.data) if @props.data.type is 1}

            </Panel>
        )


# 筛选功能
Filter = React.createClass
    getInitialState:->

        filter_title = "全部订单"
        switch @props.status
            when "all"
                filter_title = "全部订单"
            when "pending"
                filter_title = "待付款"
            when "notyetshiped"
                filter_title = "待发货"
            when "shiping"
                filter_title = "待收货"
            when "evaluate"
                filter_title = "待评价"
            when "cancel"
                filter_title = "已取消"

        {
            filterBox1: false,
            filterBox2: false,
            filter_title: filter_title
        }
    onModalHide: ->
        state = @state;
        state.filterBox1 = false;
        state.filterBox2 = false;
        this.setState(state);
    loadList: (state)->
        @onModalHide()

        url = '/member/order/'+ state
        SP.redirect(url,true);

        mystate = @state
        switch state
            when "all"
                mystate.filter_title = "全部订单"
            when "pending"
                mystate.filter_title = "待付款"
            when "notyetshiped"
                mystate.filter_title = "待发货"
            when "shiping"
                mystate.filter_title = "待收货"
            when "evaluate"
                mystate.filter_title = "待评价"
            when "cancel"
                mystate.filter_title = "已取消"

        @setState(mystate)

        state_id = null

        switch state
            when "all"
                state_id = 0
            when "pending"
                state_id = 1
            when "notyetshiped"
                state_id = 3
            when "shiping"
                state_id = 4
            when "evaluate"
                state_id = 5
            when "cancel"
                state_id = 6

        S("order-list",{
            status_id: state_id
        });
        A("order-list").getOrderList(1);

    # 所有订单
    onOrderAll: ->
        @loadList("all")
    # 待付款
    onOrderPending: ->
        @loadList("pending")
    # 待发货
    onOrderNotyetshiped: ->
        @loadList("notyetshiped")
    # 待收货
    onOrderShiping: ->
        @loadList("shiping")
    # 待评价
    onOrderEvaluate: ->
        @loadList("evaluate")
    # 退换货
    onOrderAftersales: ->
        @onModalHide()
        SP.redirect('/member/aftersales',true);
    # 已取消
    onOrderCancel: ->
        @loadList("cancel")
    # 近三个月
    onThreeMouth: ->
        store = S("order-list")
        store.begin_at = false
        S("order-list",store);
        @loadList(@props.status)
    # 三个月前
    onBeforeThreeMouth: ->
        store = S("order-list")
        store.begin_at = true
        S("order-list",store);
        @loadList(@props.status)
    renderTypeFilterModal: ->
        return (
            <Modal margin={0} maskClose={true} position="bottom" name="orderListAllHanderModal" onCloseClick={@onModalHide} show={@state.filterBox1}>
                <div className="orderHanderButtons">
                    <Button onTap={@onOrderAll} bsStyle='primary' block >全部订单</Button>
                    <Button onTap={@onOrderPending} bsStyle='primary' block >待付款</Button>
                    <Button onTap={@onOrderNotyetshiped} bsStyle='primary' block >待发货</Button>
                    <Button onTap={@onOrderShiping} bsStyle='primary' block >待收货</Button>
                    {#<Button onTap={@onOrderEvaluate} bsStyle='primary' block >待评价</Button>}
                    <Button onTap={@onOrderCancel} bsStyle='primary' block >已取消</Button>
                    {#<Button onTap={@onOrderAftersales} bsStyle='primary' block >退换货</Button>}
                </div>
                {#<div className="u-text-center u-mt-5 u-pb-5 u-pl-10 u-pr-10"> <Button block onTap={@onModalHide} bsStyle='primary' >取消</Button> </div>}
            </Modal>
        );
    renderTimeFilterModal: ->
        return (
            <Modal margin={0} maskClose={true} position="bottom" name="orderListAllHanderModal" onCloseClick={@onModalHide} show={@state.filterBox2}>
                <div className="orderHanderButtons">
                    <Button onTap={@onThreeMouth} bsStyle='primary' block >近三个月</Button>
                    <Button onTap={@onBeforeThreeMouth} bsStyle='primary' block >三个月前</Button>
                </div>
                {#<div className="u-text-center u-mt-5 u-pb-5 u-pl-10 u-pr-10"> <Button block onTap={@onModalHide} bsStyle='primary' >取消</Button> </div>}
            </Modal>
        );
    # 全部订单
    onShowAllOrder: (e)->
        e.stopPropagation()
        e.preventDefault()
        state = @state;
        state.filterBox1 = true;
        this.setState(state);
    # 近三个月订单
    onShowLastMouth: (e)->
        e.stopPropagation()
        e.preventDefault()
        state = @state;
        state.filterBox2 = true;
        this.setState(state);
    # 搜索
    onReach: ->
    render: ->
        return (
            <div className="filter">
                {@renderTypeFilterModal()}
                {@renderTimeFilterModal()}
                <div className="filter-inner">
                    <Grid cols={24}>
                        <Col span={12}>
                            <Tappable onTap={@onShowAllOrder} component="div" className="filter-item filter-item-drop-down">
                                <span className="filter-title">{@state.filter_title}</span><Button bsStyle="icon" icon="arrowdownlarge" />
                            </Tappable>
                        </Col>
                        <Col span={12}>
                            <Tappable onTap={@onShowLastMouth} component="div" className="filter-item filter-item-drop-down">
                                <span className="filter-title">{if S('order-list').begin_at then "三个月前" else "近三个月"}</span><Button bsStyle="icon" icon="arrowdownlarge" />
                            </Tappable>
                        </Col>
                    </Grid>

                </div>
            </div>
        )

PageView = React.createClass
    mixins: [MemberCheckLoginMixin,liteFlux.mixins.storeMixin(pageStore)],
    # 如果未登录
    _logoutCallback: ->
        SP.redirect('/member',true);
    getOrderList: (page)->
        A("order-list").getOrderList(page);
    componentDidMount: ->
        switch @props.status
            when "all"
                status = 0
            when "pending"
                status = 1
            when "notyetshiped"
                status = 3
            when "shiping"
                status = 4
            when "evaluate"
                status = 5
            when "cancel"
                status = 6
        S("order-list",{
            status_id: status
        });
        @getOrderList(1)
    componentWillUnmount: ->
        liteFlux.store(pageStore).reset();
    goToHome: ->
        SP.redirect('/');
    canRefresh: ->
        return @state['order-list'].current_page != @state['order-list'].last_page
    pushLoad: (loaded)->
        @getOrderList(@state['order-list'].current_page+1);
        loaded()
    renderList: ->
        self = this
        ItemSpan = (data)->
            data.map (item,index)->
                <OrderItem list={data} index={index} key={item.order_no} data={item} reload={self.getOrderList} showHandle={false} />

        if @state['order-list'].data.length
            return (
                <PagePushContent onPushRefresh={@pushLoad} canRefresh={@canRefresh}>
                    <Filter status={self.props.status} />
                    {ItemSpan(@state['order-list'].data)}
                </PagePushContent>
            )
        else
            btn = <Button bsStyle='primary' large className="u-mt-10" onTap={@goToHome}>返回首页</Button>
            texts = [
                "您还没有订单哦"
                "您可以回首页挑选喜欢的商品"
            ]
            return (
                <PageContent className="bg-white">
                    <Filter status={self.props.status} />
                    <Empty btn={btn} texts={texts}/>
                </PageContent>

            )
    render: ->
        state = @state;
        <Page navbar-through className="profile-order">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="我的订单" />
            {@renderList()}
        </Page>

module.exports = PageView;
