
# <Link href="/member/order/status/pending">待付款</Link>
OrderBadge = React.createClass
    render: ->
        if this.props.num && parseInt(this.props.num)>0
            <Badge className="icon-link-badge">{this.props.num}</Badge>
        else
            <span></span>

PageView = React.createClass
    mixins: [liteFlux.mixins.storeMixin("member")],

    getName: ->
        memberStore = S("member");
        if(memberStore.name)
            return (
                <div className="username-box">
                    <span className="name">{memberStore.name}</span>
                </div>
            );
        else
            return (
                <div className="username-box">
                    <Link className="member-login-link" onTap={this.checkLogin.bind(null,'/member')}>Hi~ 请登录</Link>
                </div>
            );

    checkLogin: (url)->

        if(A("member").islogin())
            SP.redirect(url);
        else
            SP.loadLogin
                success: ->
                    #window.location.reload();
                    SP.redirect(url);

    logout: ->

        A("member").logout ->
            SP.message
                msg: "登出成功!"
                callback: ->
                    window.location.reload();

    componentDidMount: ->
        # 获取最新的用户信息
        if(!A("member").islogin())
            A("member").getMemberInformation().then (res)->
                A("member").login(res)

        # 获取最新的订单数据
        if(A("member").islogin())
            A("member").getOrderStatistics()

        # 微信分享
        shareWeixinData = S("share").shareData;
        shareWeixinData.link = location.href;  # 分享链接
        A('share').setShareData(shareWeixinData);

    componentWillUnmount: ->
        A('share').resetShareData();

    loadMeiQia: ->
        if typeof mechatClick != 'undefined'
            mechatClick();

    render: ->

        self = this;
        memberStore = S("member")

        logoutBtn = ->
            if(memberStore.id)
                <ListView className="member-index-menu u-mb-10">
                    <ListView.Item hasTap icon="signout" onTap={self.logout} title="退出登录" />
                </ListView>


        allorder_click = ->
            if sipinConfig.env == "production"
                liteFlux.event.emit('click99',"click", "btn_order");

        waiting_for_payment_click = ->
            if sipinConfig.env == "production"
                liteFlux.event.emit('click99',"click", "btn_waiting_for_payment");

        waiting_for_shipping_click = ->
            if sipinConfig.env == "production"
                liteFlux.event.emit('click99',"click", "btn_waiting_for_shipping");

        waiting_fo_receive_click = ->
            if sipinConfig.env == "production"
                liteFlux.event.emit('click99',"click", "btn_waiting_fo_receive");

        my_info_click = ->
            if sipinConfig.env == "production"
                liteFlux.event.emit('click99',"click", "btn_my_info");

        my_favorite_click = ->
            if sipinConfig.env == "production"
                liteFlux.event.emit('click99',"click", "btn_my_favorite");

        my_points_click = ->
            if sipinConfig.env == "production"
                liteFlux.event.emit('click99',"click", "btn_my_points");

        my_coupon_click = ->
            if sipinConfig.env == "production"
                liteFlux.event.emit('click99',"click", "btn_my_coupon");

        my_recommendation_click = ->
            if sipinConfig.env == "production"
                liteFlux.event.emit('click99',"click", "btn_my_recommendation");

        my_cart_click = ->
            if sipinConfig.env == "production"
                liteFlux.event.emit('click99',"click", "btn_my_cart");

        online_customer_service_click = ->
            if sipinConfig.env == "production"
                liteFlux.event.emit('click99',"click", "btn_online_customer_service");


        return (
            <Page className="member-index">
                <Navbar transparent leftNavbar={<BackButton />} />
                <PageContent>
                    <div className="member-banner">
                        <div className="avatar">
                            <Img w={80} src="images/avatar-member-default.png" />
                        </div>
                        {this.getName()}
                    </div>
                    <ListView>
                        <ListView.Item beforeAction={allorder_click} onTap={this.checkLogin.bind(null,'/member/order/all')} arrow title="全部订单" />
                    </ListView>
                    <div className="order-menu-list">
                        <Grid cols={24}>
                            <Col span={8} className="u-text-center">
                                <Link beforeAction={waiting_for_payment_click} onTap={this.checkLogin.bind(null,'/member/order/pending')} arrow className="icon-link" >
                                    <OrderBadge num={memberStore.orderStatistics[1]} />
                                    <i className="icon icon-wallet"></i>
                                    <span className="tabbar-label">待付款</span>
                                </Link>
                            </Col>
                            <Col span={8} className="u-text-center">
                                <Link beforeAction={waiting_for_shipping_click} onTap={this.checkLogin.bind(null,'/member/order/notyetshiped')} arrow className="icon-link" >
                                    <OrderBadge num={memberStore.orderStatistics[3]} />
                                    <i className="icon icon-car"></i>
                                    <span className="tabbar-label">待发货</span>
                                </Link>
                            </Col>
                            <Col span={8} className="u-text-center">
                                <Link beforeAction={waiting_fo_receive_click} onTap={this.checkLogin.bind(null,'/member/order/shiping')} arrow className="icon-link" >
                                    <OrderBadge num={memberStore.orderStatistics[4]} />
                                    <i className="icon icon-sign"></i>
                                    <span className="tabbar-label">待收货</span>
                                </Link>
                            </Col>
                        </Grid>
                    </div>
                    <ListView className="member-index-menu u-mb-10">
                        <ListView.Item beforeAction={my_info_click} icon="message" onTap={this.checkLogin.bind(null,'/member/profile')} arrow title="我的信息" />
                        <ListView.Item beforeAction={my_favorite_click} icon="collection" onTap={this.checkLogin.bind(null,'/member/favorite')} arrow title="我的收藏" />
                        {<ListView.Item beforeAction={my_points_click} icon="integration" onTap={this.checkLogin.bind(null,'/member/point')} arrow data-href="/member/point" title="我的积分" />}
                        <ListView.Item beforeAction={my_coupon_click} icon="coupon" onTap={this.checkLogin.bind(null,'/member/coupon')} arrow title="我的优惠券" />
                        <ListView.Item icon="vip" onTap={this.checkLogin.bind(null,'/member/service-card')} arrow title="会员权益卡" />
                        <ListView.Item beforeAction={my_recommendation_click} icon="myrecommendation" onTap={this.checkLogin.bind(null,'/member/referral')} arrow title="我的推荐" />
                        {#<ListView.Item icon="fix" onTap={this.checkLogin.bind(null,'/member/aftersales')} arrow title="售后服务" />}
                        <ListView.Item beforeAction={my_cart_click} icon="cart" href="/cart" noread={memberStore.total_quantity} title="我的购物车" />
                        <ListView.Item beforeAction={online_customer_service_click} icon="service" onTap={this.loadMeiQia} arrow title=" 在线客服" />
                    </ListView>
                    {logoutBtn()}
                </PageContent>
            </Page>
        );

module.exports = PageView;
