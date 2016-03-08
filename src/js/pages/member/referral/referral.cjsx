###
# Coupon.
# @author remiel.
# @page Coupon
###
is_weixin = ->
    ua = navigator.userAgent.toLowerCase()
    (/MicroMessenger/i).test ua

referral = React.createClass
    mixins: [liteFlux.mixins.storeMixin('referral')]

    # # 如果未登录
    # _logoutCallback: ->
    #     SP.redirect('/member',true);

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

    shareWeiboData: ->
        shareData =
            title: '抽奖赢取Apple Watch', # 分享标题
            desc: "斯品家居送礼啦，家具1元秒杀，还可参与抽奖赢取Apple Watch！快来注册吧"
            link: this.state.referral.link , # 分享链接
            imgUrl: 'http://7viii7.com2.z0.glb.qiniucdn.com/2015/07/11/f4d8332b_weibo_referral.jpg', # 分享图标
            weiboAppKey: "1229563682"
        shareData
    shareWeixinData: ->
        shareData =
            title: '抽奖赢取Apple Watch', # 分享标题
            desc: "送礼啦！ 推荐好友注册拿礼品。更有 AppleWatch 等你拿！"
            link: this.state.referral.link , # 分享链接
            imgUrl: 'http://7viii7.com2.z0.glb.qiniucdn.com/2015/07/11/f4d8332b_weibo_referral.jpg', # 分享图标
            weiboAppKey: "1229563682"
        shareData
    componentDidMount: ->
        self = this
        if this.isLogin()
            A('referral').getList()
            A('share').setShareData this.shareWeixinData()
        return

    componentWillUnmount: ->
        A('share').resetShareData();

    canRefresh: ->
        if this.state.referral.active==1
            return @state['referral'].current_page and (@state['referral'].current_page != @state['referral'].last_page)
        else
            return false
    pushLoad: (loaded)->
        A('referral').getList(@state['referral'].current_page+1);

    changeTab: (index)->
        A('referral').onChangeTab(index)

    renderHeader: ->
        tab1Class = tab2Class = tabClass = "u-flex-item-1 u-black-link"

        if this.state.referral.active==0
            tab1Class +=' active'
            # 隐藏加载区
            if document.querySelectorAll(".push-refresh-tip").length
                document.querySelectorAll(".push-refresh-tip")[0].style.display = 'none'
        else if this.state.referral.active==1
            tab2Class +=' active'
            if document.querySelectorAll(".push-refresh-tip").length
                document.querySelectorAll(".push-refresh-tip")[0].style.display = ''

        <header className="referral-hd u-flex-box u-f14">
            <Tappable component="div" onTap={this.changeTab.bind(null,0)} className={tab1Class}>我要推荐</Tappable>
            <Tappable component="div" onTap={this.changeTab.bind(null,1)} className={tab2Class}>推荐记录</Tappable>
        </header>

    renderToolbar: ->
        <Toolbar>
            <div className="u-pl-20">
                <span className="u-mr-20">已荐人数: <em className="u-color-gold u-f16">{@state.referral.total_members}</em></span>
                <span>所获积分: <em className="u-color-gold u-f16">{@state.referral.total_points}</em></span>
            </div>
        </Toolbar>

    renderItem: (item)->
        <div className="referral-item" key={item.id}>
            <Grid cols={24}>
                <Col span={16}>
                    <div className="referral-item-label">
                        <label>{"用\u00A0\u00A0户\u00A0\u00A0名:"}</label>
                        <span>{item.invitee_name}</span>
                    </div>
                    <div className="referral-item-label">
                        <label>{"注册时间:"}</label>
                        <span>{item.register_at}</span>
                    </div>
                </Col>
                <Col span={8} className="u-text-right points">
                    +{item.point}
                </Col>
            </Grid>
        </div>

    onShareWeibo: ->
        A('share').onShareWeibo(this.shareWeiboData())

    onShareWeixin: ->
        if(!is_weixin())
            S "referral",{
                is_weixin: false
            }
        else
            S "referral",
                is_weixin: true

            SP.message
                msg: "请点击右上角分享给朋友们"



    renderBody: ->
        self = this
        renderItems = ->
            list = self.state.referral.list
            if list.length
                list.map (item)->
                    self.renderItem(item)
            else
                texts = [
                    "暂时没有推荐记录"
                    "向您的朋友推荐注册斯品网站，可获取积分奖励"
                ]
                return (
                    <Empty texts={texts}/>
                )

        if !this.state.referral.is_weixin
            tipsClass = "tips"
        else
            tipsClass = "tips u-none"

        if this.state.referral.active==0
            if this.isLogin()
                <div className="referral-info">
                    <h4>访问推荐链接</h4>
                    <p>1.如果您的朋友通过下面的邀请链接访问站点并注册成会员，您将获得<span className="blackred">500</span>积分奖励；</p>
                    <p>2.如果您的朋友通过下面的邀请链接访问站点并注册成会员，您的朋友将同时获得<span className="blackred">300</span>积分奖励。</p>
                    <h4 className="u-mt-15">获取推荐链接</h4>
                    <p>以下是你的专属二维码及专属链接，长按即可复制链接或截屏保存二维码</p>
                    <div className="u-text-center w100 u-mt-15"><Img width="150" src={window.apihost + '/qrcode?return_type=image&url=' + decodeURIComponent @state.referral.link} /></div>
                    <div className="referral-url u-mt-15">
                        <div className="referral-url-input" >{this.state.referral.link}</div>
                    </div>
                    <div className="u-mt-20 u-color-gray-label">
                        或分享至: <Button onTap={@onShareWeibo} bsStyle="icon" icon='weibo' /> <span className="u-color-border">|</span> <Button onTap={@onShareWeixin} bsStyle="icon" icon='weixin' />
                    </div>
                    <div className={tipsClass}>
                        请使用手机截屏，用微信扫描该二维码即可分享复制专属链接，在微信中发送给好友吧
                    </div>
                </div>
            else
                <div className="referral-info">
                    <h4>访问推荐链接</h4>
                    <p>1.如果您的朋友通过下面的邀请链接访问站点并注册成会员，您将获得<span className="blackred">500</span>积分奖励；</p>
                    <p>2.如果您的朋友通过下面的邀请链接访问站点并注册成会员，您的朋友将同时获得<span className="blackred">300</span>积分奖励。</p>
                    <h4 className="u-mt-15">获取推荐链接</h4>
                    <div className="u-text-center u-mt-15">
                        <Button onTap={@login} large bsStyle="primary">立即登录</Button>
                    </div>
                </div>
        else
            <div className="referral-list">
                {renderItems()}
            </div>

    render: ->

        # 列表为空与我的推荐时，页面为白底
        if this.state.referral.active==0 || !this.state.referral.list.length
            pageClass = "bg-white"

        <Page navbar-through toolbar-through className="member-referral">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="我的推荐"></Navbar>
            {@renderToolbar() if this.state.referral.active==1 and this.state.referral.list.length}
            <PagePushContent className={pageClass} onPushRefresh={@pushLoad} canRefresh={@canRefresh}>
                {@renderHeader()}
                {@renderBody()}
            </PagePushContent>
        </Page>


module.exports = referral
