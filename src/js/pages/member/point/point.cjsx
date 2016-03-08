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
        # Action.getList()
        # Action.getPoint()

    pushLoad: () ->
        Action.loadMore()
    canRefresh: () ->
        point = @state.point
        list = point.list
        ret
        if list isnt null and list.current_page
            ret = list.current_page isnt list.last_page
        else
            ret = no
        ret

    renderBar: () ->
        <Toolbar>
            <div className="point-bar u-color-gray-summary">
                您目前可用积分：<span className="u-color-gold u-f16">{@state.point.available_point}</span>
            </div>
        </Toolbar>

    renderList: () ->
        point = @state.point
        list = point.list
        return <div></div> if list is null
        if not list.data.length

            texts = [
                "暂无积分"
            ]

            return <Empty texts={texts}/>


        list.data.map (item, i) ->
            pointClasses = SP.classSet
                "u-fr": yes
                'u-color-blackred': item.operational_point < 0
                'u-color-green': item.operational_point > 0
            point = if item.operational_point > 0 then '+' + item.operational_point else item.operational_point
            <div className="point-item" key={i}>
                <div>
                    <span className="u-f14">{item.type_name}</span>
                    <span className={pointClasses}>{point}</span>
                </div>
                <div className="u-color-gray-summary">
                    <span>{item.source || "\u00A0"}</span>
                    <span className="u-fr">{item.created_at}</span>
                </div>
            </div>

    renderTab: () ->
        <Tab>
            <TabItem className="active">积分明细</TabItem>
            <TabItem href="/member/point/exchange">积分兑换</TabItem>
        </Tab>


    render: ->
        point = @state.point
        if point.available_point is null
            return <Loading />
        <Page navbar-through toolbar-through className="member-point">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="我的积分"></Navbar>
            {@renderBar()}
            <PagePushContent onPushRefresh={@pushLoad} canRefresh={@canRefresh}>
                {@renderList()}
            </PagePushContent>
        </Page>


module.exports = Point
