###
# lottery
# @author remiel.
# @page lottery
###
moment = require 'moment'
T = React.PropTypes
AddressStore = appStores.address
NewAddressStore = appStores.newAddress
Store = appStores.lottery
Action = Store.getAction()

is_weixin = ->
    ua = navigator.userAgent.toLowerCase()
    (/MicroMessenger/i).test ua

PageView = React.createClass

    mixins: [liteFlux.mixins.storeMixin('lottery')]
    # mixins: [MemberCheckLoginMixin, liteFlux.mixins.storeMixin('lottery')]
    # 如果未登录
    # _logoutCallback: ->
    #     SP.redirect('/activity/july',true)

    propTypes:
        id: T.string
        Activity: T.string
        shareUrl: T.string
    getDefaultProps: ->
        activityUrl: '/'
        shareUrl: window.location.href

    getInitialState: (props)->
        # content = @renderResultText({
        #     prize_name: '324'
        #     prize_type: 2
        # })
        # title = @renderResultTitle({
        #     prize_name: '324'
        #     prize_type: 2
        # })
        # img = @renderResultImg({
        #     prize_name: '324'
        #     prize_type: 2
        # })
        #
        #
        # SP.alert
        #     content: @renderResultAlert(title, content, img)
        #     bsStyle: 'red'
        #     name: 'july-lottery-alert-modal'
        #     margin: 15
        #     confirmText: "马上填写收货地址"
        #     confirm: () =>
        #         @showAlert()


        props = props || @props
        Action.reset()
        Action.setLotteryId props.id

        Action.getLottery props.id
        Action.getPrizeList props.id
        Action.getEligibility props.id
        Action.getPublicResult props.id
        if @isLogin()
            Action.getMyResult props.id
            Action.checkAttendance props.id

            A('address').getAddress()
            NewAddressStore.getAction().reset()

        {}

    componentDidMount: ->
        # 已移到store里
        # A('share').setShareData this.shareWeixinData()

    componentWillUnmount: ->
        A('share').resetShareData();

    componentWillReceiveProps: (props) ->
        @getInitialState props if @state.lottery.id isnt props.id

    # 已移到store里
    # shareWeiboData: ->
    #     shareData =
    #         title: '斯品幸运大转盘' # 分享标题
    #         desc: '来参与斯品家居幸运大转盘活动，好礼送给你，100%中奖哦！'
    #         link: @props.shareUrl
    #         imgUrl: 'http://7sbwdf.com2.z0.glb.qiniucdn.com/55c0667d7b264_lottery.jpg' # 分享图标

    # 已移到store里
    # shareWeixinData: ->
    #     shareData =
    #         title: '斯品幸运大转盘' # 分享标题
    #         desc: '来斯品参与抽奖，好礼送给你，100中奖哦！'
    #         link: @props.shareUrl
    #         imgUrl: 'http://7sbwdf.com2.z0.glb.qiniucdn.com/55c0667d7b264_lottery.jpg?imageView2/2/w/200/q/80' # 分享图标
    #         successCallback: () ->
    #             Action.setAttendance 1

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

    loginSetAttendance: () ->
        @setAttendance().then (res) =>
            window.location.reload()

    start: () ->
        Action.draw()

    callback: () ->
        # SP.message
        #     msg: '抽到啦, 我擦'
        # @showAlert()
        store = @state.lottery
        result = store.result
        type = result.prize_type
        content = @renderResultText(result)
        title = @renderResultTitle(result)
        img = @renderResultImg(result)
        if type is 2 or type is 5
            SP.alert
                content: @renderResultAlert(title, content, img)
                bsStyle: 'red'
                name: 'july-lottery-alert-modal'
                margin: 15
                confirmText: "马上填写收货地址"
                confirm: () =>
                    # 空地址
                    # @showAlert()
                    # 读取默认地址
                    @getDefaultAddress()
                    yes
                cancel: () =>
                    Action.setResult null
        else
            SP.alert
                content: @renderResultAlert(title, content, img)
                bsStyle: 'red'
                name: 'july-lottery-alert-modal'
                margin: 15
            Action.setResult null

        Action.getPublicResult @props.id
        Action.getMyResult @props.id

    renderResultAlert: (title, content, img) ->
        <div className="u-pt-30 u-pr-15 u-pl-15 u-text-center u-color-white">
            {title}
            {content}
            {img}
        </div>

    renderResultTitle: (result) ->
        # 0 - 积分
        # 1 - 优惠券
        # 2 - 实体商品
        # 3 - 再来一次
        # 4 - 空
        type = result.prize_type
        name = result.prize_name
        node = ''
        switch type
            when 0
                node =
                    <div className="u-f14 u-mb-15">
                        恭喜您获得了由斯品商城提供的
                        <div className="u-f18 u-color-yellow">{result.prize_name}</div>
                    </div>
            when 1
                node =
                    <div className="u-f14 u-mb-15">
                        恭喜您获得了由斯品商城提供的
                        <div className="u-f18 u-color-yellow">{result.prize_name}</div>
                    </div>
            when 2
                node =
                    <div className="u-f14 u-mb-15">
                        恭喜您获得了由斯品商城提供的
                        <div className="u-f18 u-color-yellow">{result.prize_name}</div>
                    </div>
            when 5
                node =
                    <div className="u-f14 u-mb-15">
                        恭喜您获得了由斯品商城提供的
                        <div className="u-f18 u-color-yellow">{result.prize_name}</div>
                    </div>

        node

    renderResultText: (result) ->
        # 0 - 积分
        # 1 - 优惠券
        # 2 - 实体商品
        # 3 - 再来一次
        # 4 - 空
        type = result.prize_type
        name = result.prize_name
        node = ''
        switch type
            when 0
                node =
                    <div className="u-color-white u-opacity-6">
                        <div>积分已计入您的账户，您可以在“个人中心&gt;我的积分”中查看</div>
                    </div>
            when 1
                node =
                    <div className="u-color-white u-opacity-6">
                        <div>优惠券已计入您的账户，您可以在“个人中心&gt;我的优惠券”中查看</div>
                    </div>
            when 3
                node =
                    <div className="u-color-white u-opacity-6">
                        <div>再来一次</div>
                    </div>
            when 4
                node =
                    <div className="u-color-white u-opacity-6">
                        <div>空</div>
                    </div>

        node

    renderResultImg: (result) ->
        # 0 - 积分
        # 1 - 优惠券
        # 2 - 实体商品
        # 3 - 再来一次
        # 4 - 空
        type = result.prize_type
        name = result.prize_name
        url = if typeof result.prize_pics is 'object' then result.prize_pics.mobile_popup else ''
        node = ''
        # switch type
        #     when 0
        #         node =
        #             <div className="lottery-result-img lottery-result-img-#{type}">
        #                 <img src={"/images/lottery-july/#{type}/3.png"}/>
        #             </div>
        #     when 1
        #         node =
        #             <div className="lottery-result-img lottery-result-img-#{type}">
        #                 <img src={"/images/lottery-july/#{type}/3.png"}/>
        #             </div>
        #     when 2
        #         node =
        #             <div className="lottery-result-img lottery-result-img-#{type}">
        #                 <img src={"/images/lottery-july/#{type}/3.png"}/>
        #             </div>
        #     when 5
        #         node =
        #             <div className="lottery-result-img lottery-result-img-#{type}">
        #                 <img src={"/images/lottery-july/#{type}/3.png"}/>
        #             </div>

        node =
            <div className="lottery-result-img lottery-result-img-#{type}">
                <img src={url}/>
            </div>

        node

    getDefaultAddress: () ->
        address = S('address').list
        if address isnt null and address and address.length
            address.map (item, i) =>
                if item.is_default is 1
                    NewAddressStore.getAction().setCurrent item
        @showAlert()

    renderPublicResult: () ->
        publicResult = @state.lottery.publicResult || {}
        data = publicResult.data || []
        if data.length
            node = data.map (item, i) ->
                # member_name = item.member_name
                # len = item.member_name.length
                # if typeof item.member_name is 'string'
                #     if len > 5
                #         member_name = item.member_name.substring(0, 2) + "**" + item.member_name.substring(len-2, len)
                #     else if len = 5
                #         member_name = item.member_name.substring(0, 2) + "**" + item.member_name.substring(len-1, len)
                #     else
                #         member_name = item.member_name.substring(0, 2) + "**"
                if item.is_name_init is 0
                    name = item.member_name
                else
                    name = item.member_mobile || item.member_email
                <div key={i}>
                    <span className="lottery-marquee-public-result-span-01 u-inline-block">{name}</span>
                    <span className="u-inline-block">
                        获得<span className="u-color-yellow">{item.prize_name}</span>
                    </span>
                </div>
        else
            text = if @state.lottery.publicResult is null then "正在加载数据..." else "暂无中奖数据"
            node = <div className="u-text-center">{text}</div>

        <AutoScrollVertical className="lottery-marquee-public-result">
            {node}
        </AutoScrollVertical>

    renderMyResult: () ->
        myResult = @state.lottery.myResult || {}
        data = myResult.data || []
        if data.length
            node = data.map (item, i) ->
                <div key={i}>
                    <span className="lottery-marquee-public-result-span-01 u-inline-block">
                        获得<span className="u-color-yellow">{item.prize_name}</span>
                    </span>
                    <span className="u-inline-block">{item.win_at}</span>
                </div>
        else
            text = if @state.lottery.myResult is null then "正在加载数据..." else "暂无中奖数据"
            node = <div className="u-text-center">{text}</div>

        <AutoScrollVertical className="lottery-marquee-mine-result">
            {node}
        </AutoScrollVertical>

    renderTab: () ->
        <div className="lottery-marquee-tab u-flex-box">
            {@renderTabItem(0, "中奖名单公布")}
            {@renderTabItem(1, "我的中奖纪录")}
        </div>

    renderTabItem: (n, text) ->
        className = SP.classSet "lottery-marquee-tab-item u-flex-item-1",
            "active": @state.lottery.tab is n
        <Tappable className={className} onTap={@onTapTab.bind null, n} >{text}</Tappable>

    onTapTab: (n) ->
        if @state.lottery.tab isnt n
            switch n
                when 0
                    Action.getPublicResult @props.id
                    Action.tab n
                when 1
                    if @isLogin()
                        Action.getMyResult @props.id
                        Action.tab n
                    else
                        @login()

    renderTabContent: () ->
        switch @state.lottery.tab
            when 0
                node = @renderPublicResult()
            when 1
                node = @renderMyResult()
        <div className="lottery-marquee-tab-content">
            {node}
        </div>


    renderBar: () ->
        store = @state.lottery
        if not @isLogin()
            attendance = <Tappable className="lottery-bar-btn u-fr u-mr-15" onTap={@login.bind null, @loginSetAttendance}>签到</Tappable>
        else if store.attendanceStatus is null
            attendance = ""
        else if store.attendanceStatus is no
            attendance = <Tappable className="lottery-bar-btn u-fr u-mr-15" onTap={@setAttendance}>签到</Tappable>
        else
            attendance = <Tappable className="lottery-bar-btn u-fr u-mr-15 disabled">已签到</Tappable>
        share = @renderShareModal()
        <Toolbar>
            <div className="lottery-marquee-bar">
                <div className="lottery-marquee-bar-content">通过签到或者分享抽奖活动均可获得一次抽奖机会</div>
                <Alertable className="lottery-bar-btn u-fr u-mr-15" showConfirmBtn={no} contentElement={share} showCloseIcon={no} maskClose={yes}>分享</Alertable>
                {attendance}
            </div>
        </Toolbar>

    renderShareModal: ->
        <div className="u-flex-box lottery-share-modal u-text-center u-pt-20">
            <div className="u-flex-item-1">
                <Tappable className="icon icon-weibo" onTap={@onShareWeibo}>微博</Tappable>
            </div>
            <div className="u-flex-item-1">
                <Tappable className="icon icon-weixin" onTap={@onShareWeixin}>微信</Tappable>
            </div>
        </div>

    onShareWeibo: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        Action.setAttendance 2, Action.shareWeiboData()

    onShareWeixin: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        if is_weixin() is yes
            SP.message
                msg: "请点击右上角分享给朋友们"
        else
            # TODO: 二维码
            A('share').onShareQrcode(@props.shareUrl)
            Action.setAttendance 1

    setAttendance: () ->
        Action.setAttendance 0

    renderRule: () ->
        data = @state.lottery.data
        rule = if data then data.rule else ""
        rule =
            __html: rule
        rule =
            <div className="u-pt-30 u-pr-15 u-pl-15">
                <div className="u-f14 u-mb-15">抽奖规则</div>
                <div className="u-color-gray-summary" dangerouslySetInnerHTML={rule}>
                </div>
            </div>
        <Alertable className="u-f14 u-color-gray-summary" showConfirmBtn={no} showCloseIcon={yes} contentElement={rule} margun={15}>规则</Alertable>
    hideAlert: () ->
        Action.setResult null
        Action.hideAlert()
    showAlert: () ->
        Action.showAlert()
    renderResultAlertWithAddress: () ->
        name = @state.lottery.result.prize_name if @state.lottery.result and @state.lottery.result.prize_name
        <Modal name="alert-modal" title="请填写收货信息" onCloseClick={@hideAlert} show={@state.lottery.showAlert} margin={30} showCloseIcon={no}>
            <LiteNewAddress />
            <div className="u-text-center u-pb-20 u-pt-20">
                <Button onTap={@onSaveAddress} large bsStyle="primary">提交信息</Button>
            </div>
        </Modal>
    onSaveAddress: () ->
        NewAddressStore.getAction().checkAndSaveForLiteAddress(@onSaveAddressCallback)

    onSaveAddressCallback: (address_id) ->
        store = @state.lottery
        result = store.result
        Action.setAddress(result.id, address_id)
        @hideAlert()

    goToActivityPage: () ->
        SP.redirect @props.activityUrl


    render: ->
        lottery = @state.lottery
        data = lottery.data
        begin = no
        end = no
        if data and data.begin_at and moment(data.begin_at).isBefore()
            begin = yes

        if data and data.end_at and new moment().isBefore(data.end_at)
            end = yes

        # if data is null
        #     return <Loading />
        title = if data then data.title else ''
        result = lottery.result || null
        result = result.prize_id if result isnt null
        <Page navbar-through toolbar-through className="lottery lottery-marquee">
            <Navbar leftNavbar={<BackButton backPage={@props.activityUrl}/>} rightNavbar={@renderRule()} title={title}></Navbar>
            {@renderBar()}
            <PageContent>
                <LotteryMarquee data={lottery.prizeList} begin={begin} end={end} times={lottery.times} result={result} start={@start} callback={@callback} isLogin={@isLogin()} login={@login}/>
                {@renderTab()}
                {@renderTabContent()}
                {@renderResultAlertWithAddress()}
                <Tappable component="div" className="lottery-go-home icon icon-home" onTap={@goToActivityPage}>
                    返回活动首页
                </Tappable>
            </PageContent>
        </Page>


module.exports = PageView
