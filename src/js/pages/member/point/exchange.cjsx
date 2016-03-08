###
# Point.
# @author remiel.
# @page Point
###
Action = A('point')
Point = React.createClass
    mixins: [MemberCheckLoginMixin, liteFlux.mixins.storeMixin('point')]
    getInitialState: ->
        Action.getList()
        Action.getPoint()
        {}

    componentDidMount: ->
        Action.getList()
        Action.getPoint()

    pushLoad: () ->
        Action.loadMore()
    canRefresh: () ->
        point = @state.point
        list = point.list

        list.current_page isnt list.last_page

    renderBar: () ->
        <Toolbar>
            <div className="point-bar u-color-gray-summary">
                您目前可用积分：<span className="u-color-gold u-f16">123</span>
            </div>
        </Toolbar>

    renderList: () ->
        point = @state.point
        list = point.list
        return <div></div> if list.data is null
        list.data.map (item, i) ->
            pointClasses = SP.classSet
                "u-fr": yes
                'u-color-blackred': item.point < 0
                'u-color-green': item.point > 0
            item.point = '+' + item.point if item.point > 0
            <div className="point-item" key={i}>
                <div>
                    <span className="u-f14">{item.type}</span>
                    <span className={pointClasses}>{item.point}</span>
                </div>
                <div className="u-color-gray-summary">
                    <span>{item.source}</span>
                    <span className="u-fr">{item.created_at}</span>
                </div>
            </div>

    renderTab: () ->
        <Tab>
            <TabItem href="/member/point">积分明细</TabItem>
            <TabItem className="active">积分兑换</TabItem>
        </Tab>

    render: ->
        point = @state.point
        if point.available_point is null
            return <Loading />
        <Page navbar-through toolbar-through className="member-point">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="我的积分"></Navbar>
            {@renderBar()}
            <PagePushContent onPushRefresh={@pushLoad} canRefresh={@canRefresh}>
                {@renderTab()}
                {@renderList()}
            </PagePushContent>
        </Page>


module.exports = Point
