React = require 'react'
moment = require 'moment'
storeName = 'presales-home'
require 'stores/presales-detail'
Store = require 'stores/presales-home'
Action = Store.getAction()
SkuDetail = require '../detail/home-sku-detail'
BarMixins = require '../detail/bar-mixins'
PageView = React.createClass
    storeName: storeName
    mixins: [liteFlux.mixins.storeMixin(storeName), BarMixins]
    getInitialState: ->
        Action.reset()
        A('presales-detail').reset()
        Action.getList()
        {}
    tabText: [
        '预订中'
        '即将预售'
        '限量低价'
        '敬请期待'
    ]
    onChangeTab: (i) ->
        store = @state[storeName]
        index = store.tab
        if i isnt index and i isnt 3
            Action.tab i

    renderTab:() ->
        store = @state[storeName]
        index = store.tab
        list = store.list
        # tabs = @tabText.map (item, i) =>
        #     className = ''
        #     if i is index
        #         className = 'active'
        #     <TabItem className={className} onTap={@onChangeTab.bind(null, i)} key={i}>{item}</TabItem>

        tabs = list.map (item, i) =>
            className = ''
            if i is index
                className = 'active'
            if i < 4
                <TableTabItem className={className} onTap={@onChangeTab.bind(null, i)} key={i}>{@tabText[i]}</TableTabItem>
        if list.length < 4
            tabs.push (<TableTabItem key={3}>{@tabText[3]}</TableTabItem>)

        <TableTab underline>
            {tabs}
        </TableTab>

    renderList: () ->
        store = @state[storeName]
        if store.current is null
            return ''
        if store.current and store.current.mobileSliders and store.current.mobileSliders.length
            store.current.mobileSliders.map (item, i) =>
                <div className="presales-slider-item" key={i}>
                    <Img src={item.media.full_path} w={640}/>
                    <section>{store.current.description}</section>
                </div>

    render: ->
        store = @state[storeName]
        server_time = store.server_time
        current = store.current
        if not current
            return <Loading />
        skuDetail = ''
        if S('presales-detail').current
            skuDetail = <SkuDetail />


        <Page navbar-through toolbar-through className="presales-home">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="预售" />
            {@renderBar()}
            <PageContent className="bg-white">
                {@renderTab()}
                <SliderHorizontal nav nav-center nav-square>
                    {@renderList()}
                </SliderHorizontal>
                <div className="presales-home-info">
                    <h4 className="u-mb-20">
                        {current.name}
                        <Link href="/presales/detail/#{current.id}" className="u-fr u-ml-15 u-f12">详情</Link>
                        <span className="u-fr u-color-gray-summary u-f12">
                            已有<span className="u-color-red">{current.total_booking}</span>人预定 |
                        </span>
                    </h4>
                    {skuDetail}
                </div>
            </PageContent>
        </Page>
module.exports = PageView
