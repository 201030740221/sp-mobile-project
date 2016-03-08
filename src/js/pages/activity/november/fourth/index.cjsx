###
# 第四场活动
# @author remiel.
###
Events = require 'utils/events'
moment = require 'moment'
T = React.PropTypes
Store = appStores.activityNovember4
storeName = 'activity-november-4'
Action = Store.getAction()

Block1 = require './block-1'
Block2 = require './block-2'
Block3 = require './block-3'
Block4 = require './block-4'
Footer = require 'pages/website/footer'

PageView = React.createClass

    mixins: [liteFlux.mixins.storeMixin(storeName)]
    tab: [
        '拼拼手气'
        '疯狂抄底'
        '满就送'
    ]
    getInitialState: (props)->
        Action.getPageData()
        {}
    componentWillReceiveProps: (props) ->

    componentDidMount: ->


    componentWillUnmount: ->

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

    onPageScroll: () ->
        store = @state[storeName]
        hd = @refs['hd'].getDOMNode()
        bd = @refs['bd'].getDOMNode()
        nav = @refs['nav'].getDOMNode()
        nav1 = @refs['nav1'].getDOMNode()
        _top = hd.offsetHeight
        _scrollTop = bd.scrollTop
        scrollTop = _scrollTop + _top
        n = 0
        @tab.map (item, i) =>
            tabName = 'tab-' + (i + 1)
            el = @refs[tabName].getDOMNode()
            top = el.offsetTop
            if top < scrollTop + window.innerHeight/4
                n = i
            if i is 3
                if top < scrollTop + window.innerHeight/5*3
                    n = i
        if _scrollTop > nav1.offsetHeight
            nav.style.display = ''
        else
            nav.style.display = 'none'
        if +store.tab isnt +n
            Action.tab n
    renderTab: () ->
        tabs = @tab.map (item, i) =>
            @renderTabItem i, item
        <div className="activity-november-tab u-flex-box u-pf" ref="nav" style={{display: 'none'}}>
            {tabs}
        </div>
        <div className="activity-november-tab u-flex-box u-pr" ref="nav1">
            {tabs}
        </div>

    renderFixedTab: () ->
        tabs = @tab.map (item, i) =>
            @renderTabItem i, item
        <div className="activity-november-tab u-flex-box u-pf" ref="nav" style={{display: 'none'}}>
            {tabs}
        </div>


    renderTabItem: (n, text) ->
        store = @state[storeName]
        className = SP.classSet "u-flex-item-1",
            "active": store.tab is n
        <Tappable className={className} onTap={@onTapTab.bind null, n} key={n}>{text}</Tappable>

    onTapTab: (n) ->
        @goToTabContent n
        # Action.tab n

    goToTabContent: (n) ->
        hd = @refs['hd'].getDOMNode()
        bd = @refs['bd'].getDOMNode()
        nav1 = @refs['nav1'].getDOMNode()
        _top = hd.offsetHeight
        tabName = 'tab-' + (n + 1)
        el = @refs[tabName].getDOMNode()
        top = el.offsetTop
        bd.scrollTop = el.offsetTop - _top - nav1.offsetHeight

    renderTabContent: () ->
        store = @state[storeName]
        <div className="">
            {@renderBanner()}
            {@renderTabContent1()}
            {@renderTabContent2()}
            {@renderTabContent3()}
            {@renderTabContent4()}
        </div>

    renderBanner: () ->
        <img className="u-w-100 u-block" src="/images/activity/2015-11-4/img-01.png" />
    renderTabContent1: () ->
        store = @state[storeName]
        ids = store.lotteryIds
        if ids and ids.length
            <Block1 id={ids[0]} ref="tab-1"/>
    renderTabContent2: () ->
        <Block2 ref="tab-2"/>

    renderTabContent3: () ->
        <Block3 ref="tab-3"/>

    renderTabContent4: () ->
        # <Block4 ref="tab-4"/>



    render: ->
        store = @state[storeName]
        if not store.lotteryIds?
            return <Loading />
        <Page navbar-through toolbar-through className="activity-november-4" ref="page" onScroll={@onPageScroll}>
            <Navbar ref="hd" leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title={'终极返场'}></Navbar>
            <PageContent ref="bd">
                {@renderTab()}
                {@renderTabContent()}
                <Footer />
            </PageContent>
            {@renderFixedTab()}
            <LiteCart/>
        </Page>


module.exports = PageView
