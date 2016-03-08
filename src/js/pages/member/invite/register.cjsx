PageView = React.createClass
    onJumpPoint: ->
        SP.redirect '/member/point'
    onJumpAct: ->
        SP.redirect '/activity/july'
    render: ->
        return (
            <Page navbar-through className="member-invite">
                <Navbar leftNavbar={<HomeButton />} title="注册成功" />
                <PageContent className="bg-white">
                    <div className="member-invite-content">
                        <div className="member-invite-content-tips">您已成功获取<em className="a-act-red">300</em>积分！</div>
                        <div className="member-invite-content-tips">您可以用积分兑换相应的商品，完成注册后再推荐给您好友可
获得更多积分。每推荐一人成功注册便可获得<em className="a-act-red">500</em>积分。</div>
                        <div className="u-text-center u-mt-20 u-mb-20 u-pb-20 act-border-dashed">
                            <Button onTap={this.onJumpPoint} className="act-w150" bsStyle='primary'>查看我的积分</Button>
                        </div>
                        
                        <div className="u-mt-20">
                            <h4 className="u-text-center">满2000积分，即可兑换以下礼品：</h4>
                            <div className="u-pt-20 u-pb-20 u-text-center">
                                <Img src="../images/coupon_gift.jpg" />
                            </div>
                            <div className="u-text-center member-invite-act-title">暖男公仔（绅士）</div>
                        </div>
                    </div>
                </PageContent>
            </Page>
        );

module.exports = PageView;
