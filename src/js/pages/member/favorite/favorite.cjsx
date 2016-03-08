pageStore = "member-favorite";

PageView = React.createClass
    mixins: [MemberCheckLoginMixin,liteFlux.mixins.storeMixin(pageStore)],
    # 如果未登录
    _logoutCallback: ->
        if sipinConfig.env == "production"
            liteFlux.event.emit('click99',"click", "btn_userinfo");
        SP.redirect('/member',true);
    componentDidMount: ->
        A("member-favorite").getFavoriteList();
    goToHome: ->
        if sipinConfig.env == "production"
            liteFlux.event.emit('click99',"click", "btn_home");
        SP.redirect('/')
    canRefresh: ->
        return @state['member-favorite'].current_page != @state['member-favorite'].last_page
    pushLoad: (loaded)->
        A("member-favorite").getFavoriteList(@state['member-favorite'].current_page+1);
    renderList: ->
        self = this
        ItemSpan = (data)->
            data.map (item,index)->
                <Col key={item.goods_id} span={12} className="good-item-col">
                    <GoodsItem type="favorite" index={index} data={item} />
                </Col>

        if @state['member-favorite'].data.length
            return (
                <Grid cols={24}>
                    {ItemSpan(@state['member-favorite'].data)}
                </Grid>
            )
        else
            btn = <Button bsStyle='primary' large className="u-mt-10" onTap={@goToHome}>返回首页</Button>
            texts = [
                "您的收藏夹暂时没有商品"
                "您可以回首页收藏喜欢的商品"
            ]
            return (
                <Empty btn={btn} texts={texts}/>
            )
    render: ->
        state = @state;
        return (
            <Page navbar-through className="member-favorite">
                <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="我的收藏" />
                <PagePushContent className="bg-white" onPushRefresh={@pushLoad} canRefresh={@canRefresh}>
                    {@renderList()}
                </PagePushContent>
            </Page>
        )

module.exports = PageView;
