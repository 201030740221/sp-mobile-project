PageView = React.createClass
    shareWeixinData: ->
        shareData =
            title: '抽奖赢取Apple Watch', # 分享标题
            desc: "送礼啦！ 推荐好友注册拿礼品。更有 AppleWatch 等你拿！"
            link: location.href , # 分享链接
            imgUrl: 'http://7viii7.com2.z0.glb.qiniucdn.com/2015/07/11/f4d8332b_weibo_referral.jpg', # 分享图标
            weiboAppKey: "1229563682"
        shareData
    componentDidMount: ->
        self = this
        A('share').setShareData this.shareWeixinData()
        return
    componentWillUnmount: ->
        A('share').resetShareData();
    onRegister: ->
        SP.redirect '/member/register/referral/'+this.props.code
    onGetUrl: ->
        SP.redirect '/member/referral'
    onAct: ->
        SP.redirect '/activity/july'
    render: ->
        return (
            <Page navbar-through className="member-invite">
                <Navbar title="斯品家居活动分享" />
                <PageContent className="bg-white">
                    <div className="member-invite-content">
                        <div className="member-invite-content-tips u-pb-10 act-border-dashed">
                            <div>感谢参与斯品家居的推荐注册赢积分活动，积分可以当钱花，还可以换取精美礼品哟！</div>
                            <div className="member-invite-box u-mt-10">
                                <h6>我是推荐人</h6>
                                <div className="member-invite-box-inner u-f14">
                                    <p>点右上角<em className="a-act-red">“...”</em>分享此页面，推荐一人注册将获得<em className="a-act-red">500</em>积分！</p>
                                </div>
                            </div>
                            <div className="member-invite-box u-mt-10">
                                <h6>我是被推荐人</h6>
                                <div className="member-invite-box-inner u-f14">
                                    <p>1.通过此页面成功注册，即可获得<em className="a-act-red">300</em>积分！</p>
                                    <p>2.去会员中心获取链接，推荐好友注册获得推荐积分！</p>
                                    <div className="u-mt-20 u-mb-10 u-pb-10">
                                        <Button outlined rounded block onTap={this.onRegister} danger>未注册新用户？完成注册领取积分</Button>
                                    </div>
                                    <div className="u-text-center u-mt-10 u-mb-10">
                                        <Link className="u-f14" onTap={this.onGetUrl}>老用户？获取链接推荐好友</Link>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div className="u-mt-20">
                            <h4 className="u-text-center">参与活动还有机会抽奖赢取Apple Watch</h4>
                            <div className="u-pt-20 u-pb-20 u-text-center">
                                <Img src="../images/applewatch-invite.jpg" />
                            </div>
                            <div className="u-text-center member-invite-act-title">Apple Watch</div>
                            <div className="u-text-center u-mt-20 u-mb-20 u-pb-20">
                                <Button onTap={this.onAct} bsStyle='primary' className="act-w150">查看活动详情</Button>
                            </div>
                        </div>
                    </div>
                </PageContent>
            </Page>
        );

module.exports = PageView;
