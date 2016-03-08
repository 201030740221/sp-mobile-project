SortItem = require 'components/lib/list/sort-item'
Events = require 'utils/events'
assign = require 'object-assign'

GoodsStore = appStores.goodsList
goodsActions = GoodsStore.getAction()

SearchInput = require('components/lib/search-input')

trim = SP.trim

getCategory = (categories, cid)->
    if !categories
        return null
    for category in categories
        if category.id == +cid
            return category
        if category.children
            _c = getCategory(category.children, cid)
            if _c
                return _c

PageView = React.createClass
    mixins: [liteFlux.mixins.storeMixin('goods-list')]
    getStateFromStore: ->
        return liteFlux.store('goods-list').getStore()
    setStateFromStore: ->
        if this.isMounted()
            this.setState liteFlux.store('goods-list').getStore()

    componentDidMount: ->
        goodsActions.list this.query()
        this.query.keyword = this.props.keyword
        shareWeixinData = S("share").shareData
        shareWeixinData.link = location.href
        A('share').setShareData(shareWeixinData)

    componentWillReceiveProps: (props)->
        _this = this
        data = this.query()
        data.category_id = props.id
        data.keyword = props.keyword
        data.page = 1

        goodsActions.list data

    componentWillUnmount: ->
        A('share').resetShareData()
        # liteFlux.store("goods-list").reset()

    query: ->
        this.params = assign {
            category_id: this.props.id
            keyword: trim(this.props.keyword)
            sort: 'update-asc'
            page: 1
        }, this.params

        return this.params

    onSort: (name, order)->

        if sipinConfig.env == "production"
            liteFlux.event.emit('click99',"click", "btn_sort_"+name+'_'+order)

        data = this.query()
        data.page = 1

        if order == 'desc'
            data.sort = name + '-desc'
        else
            data.sort = name + '-asc'

        goodsActions.list data

    canRefresh: ->
        pager = this.state.pager
        isLastPage = pager.current_page == pager.last_page
        canRefresh = this.state.goodsList.length && !isLastPage

        return canRefresh
    pushLoad: (loaded)->
        data = this.query()
        data.page = this.state.pager.current_page + 1

        goodsActions.list data, loaded

    keywordChange: (keyword)->
        this.query.keyword = keyword

    searching: ->
        self = this

        S('suggestion', {
            list: []
        })
        if !this.query.keyword
            return

        # 99click 搜索统计
        if sipinConfig.env == "production"
            setTimeout ->
                liteFlux.event.emit('click99',"search", self.query.keyword);
            , 500

        SP.redirect '/search/' + encodeURIComponent(trim(this.query.keyword))

    render: ()->
        cols = 2
        nav_right = <HomeButton />
        isSearching = this.props.type == 'search'
        category = this.state.category
        title = if category then category.name else ''
        keyword = decodeURIComponent(this.props.keyword)

        if isSearching
            title = <SearchInput placeholder="搜索您需要的商品" onChange={this.keywordChange} value={keyword}/>
            nav_right = <div className="search-btn" onClick={this.searching}>搜索</div>

        goodsCols = this.state.goodsList.map (goods, i)->
            return (
                <Col className="good-item-col" key={i}>
                    <GoodsItem type="goodlist" data={goods} />
                </Col>
            )

        isEmpty = !goodsCols.length
        empty_tip = ''
        if isEmpty && !this.state.loading
            texts = [
                "该分类下暂时没有商品"
            ]

            if isSearching

                texts = [
                    "抱歉，没有找到“#{keyword}”相关商品",
                    '您可以输入其他关键词试试看'
                ]

            empty_tip = <Empty texts={texts}/>

        return (
            <Page navbar-through className="goods-list">
                <Navbar leftNavbar={<BackButton />} rightNavbar={nav_right}>{title}</Navbar>
                <Suggestion/>
                <PagePushContent className="bg-white" onPushRefresh={@pushLoad} canRefresh={@canRefresh}>
                    <Grid cols={24} className="filter">
                        <Col span={12} className="filter-item">
                            <SortItem desc onChange={this.onSort} name="update">上架时间</SortItem>
                        </Col>
                        <Col span={12} className="filter-item">
                            <SortItem onChange={this.onSort} name="price">价格</SortItem>
                        </Col>
                        <Col span={6} className="filter-item u-none">
                            <Tappable onTap={@onReach} component="div">筛选</Tappable>
                        </Col>
                    </Grid>
                    <Grid avg={cols}>
                        {goodsCols}
                    </Grid>
                    {empty_tip}
                </PagePushContent>
                <LiteCart />
            </Page>
        );

module.exports = PageView;
