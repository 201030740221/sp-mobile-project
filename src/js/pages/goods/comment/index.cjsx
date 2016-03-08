###
# Comment
# @author remiel.
# @page Comment
###
Store = appStores.comment
Action = Store.getAction()
SliderBox = require 'components/lib/slider-box'
Item = require './item'

PageView = React.createClass
    mixins: [liteFlux.mixins.storeMixin('comment')]
    getInitialState: ->
        @getList @props.id
        {}
    componentWillReceiveProps: (props) ->
        Action.reset()
        @getList props.id

    getList: (sn) ->
        Action.getList
            sku_sn: sn

    pushLoad: () ->
        Action.loadMore
            sku_sn: @props.id
    canRefresh: () ->
        store = @state.comment
        list = store.list
        if list isnt null and list.current_page
            ret = list.current_page < list.last_page
        else
            ret = no
        ret
    componentDidMount: ->
        # 微信分享
        shareWeixinData = S("share").shareData;
        shareWeixinData.link = location.href;  # 分享链接
        A('share').setShareData(shareWeixinData);
    componentWillUnmount: ->
        Action.reset()

    renderList: () ->
        store = @state.comment
        list = store.list
        if list.data.length
            list.data.map (item, i) =>
                <Item data={item} key={i}/>
        else
            <Empty texts={["暂无评论","您可以前往我的订单评价商品，快来抢沙发~"]}/>

    render: ->
        store = @state.comment
        if store.list is null
            return <Loading />

        <Page navbar-through toolbar-through className="goods-comment">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="评价晒单"></Navbar>
            <PagePushContent onPushRefresh={@pushLoad} canRefresh={@canRefresh} className="bg-white">
                <div className="comment-list">
                    {@renderList()}
                </div>
            </PagePushContent>
        </Page>

module.exports = PageView
