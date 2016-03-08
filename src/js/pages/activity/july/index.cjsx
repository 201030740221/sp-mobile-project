Slide = require('components/lib/slider-box')
ReactTabs = require('components/lib/tabs/index')
store = appStores.activityJuly
pageStore = 'activity-july'
moment = require 'moment'
Tab = ReactTabs.Tab
Tabs = ReactTabs.Tabs
TabList = ReactTabs.TabList
TabPanel = ReactTabs.TabPanel

moment = require('moment');
CountDown = require('components/lib/count-down');

CountDownContent = React.createClass
    render: ->
        <span className="u-color-blackred">{this.props.days + "天 " + this.props.hours + ":" + this.props.minutes + ":" + this.props.seconds}</span>

# 广告图片组件
AdBanner = React.createClass
    render: ->
        <div className="activity-july-banner">
            <div className="activity-july-banner-inner">
                <Link className="activity-july-banner-inner-link" href={this.props.href} />
                <Link onTap={this.props.onTap || null} className="activity-july-banner-inner-close" />
                <img width="100%" src={this.props.bg} />
            </div>
        </div>


# 积分兑换
ConvertGoods = React.createClass
    render: ->
        startDiff = moment( '2015-07-20 00:00:00' ).diff( moment(), 'seconds')

        if startDiff < 0
            exchangeBtn = <ExchangeToCart component={Button} className="act-color-red" danger data={this.props.data}>我要兑换</ExchangeToCart>
        else
            exchangeBtn = <Button disabled={true} className="act-color-red" danger>7月20日开启兑换</Button>


        <Grid cols={24} className="convert-goods bg-convert-goods">
            <Col span={12} className="convert-goods-img">
                <Img src={this.props.data.img} />
            </Col>
            <Col span={12} className="convert-goods-info">
                <h3>{this.props.data.title}</h3>
                <div className="convert-goods-info-desc">
                    {this.props.data.desc}
                </div>
                <div className="convert-goods-info-price">
                    活动期间兑换积分：{this.props.data.point}
                </div>
                <div className="convert-goods-info-label">
                    可兑换数量：{this.props.data.stock}
                </div>
                <div className="convert-goods-info-sumbit">
                    {exchangeBtn}
                </div>
            </Col>
        </Grid>

# <Button className="act-color-red" danger>我要兑换</Button>
# 明星商品单项
StarGoodsItem = React.createClass
    onAddToCart: (id)->
        liteFlux.action("cart").addToCart id

    render: ->
        <div className="good-item">
            <div className="good-item-inner">
                <div className="good-item-image u-text-center">
                    <Link href={"/item/" + @props.data.sku_sn}>
                        <Img src={@props.data.img} w={320} />
                    </Link>
                </div>
                <div className="good-item-title u-text-center">
                    <h3><Link href={"/item/" + @props.data.sku_sn}>{@props.data.title}</Link></h3>
                    <div className="price">
                        ￥{@props.data.price}
                    </div>
                </div>
                <div className="good-item-actions u-text-center">
                    <AddToCart><Tappable onTap={this.onAddToCart.bind(null,@props.data.sku_id)} bsStyle="link"  name="tocart">+ 购物车</Tappable></AddToCart>
                </div>
            </div>
        </div>

# 明星商品
StarGoods = React.createClass
    render: ->
        <Grid cols={24} className="starGoods">
            <Col span={12} className="convert-goods-img">
                <StarGoodsItem data={this.props.data[0]} />
            </Col>
            <Col span={12} className="convert-goods-info">
                <StarGoodsItem data={this.props.data[1]} />
            </Col>
        </Grid>

# 如何获取积分
HowToGetPoints = React.createClass
    render: ->
        <div className="howToGetPoints">
            <h3>如何获取积分?</h3>
            <Grid cols={24} className="howToGetPoints-box">
                <Col span={8} className="howToGetPoints-box-item">
                    <Link className="howToGetPoints-box-item-absolute-link" href="/member/referral"></Link>
                    <h4>01.</h4>
                    <div className="howToGetPoints-box-item-desc">推荐好友注册获积分</div>
                    <div className="howToGetPoints-box-item-link _howToGetPoints-box-item-link1 "><Link href="#">立即前往 ></Link></div>
                </Col>
                <Col span={8} className="howToGetPoints-box-item">
                    <div className="icon-prize"></div>
                    <Link className="howToGetPoints-box-item-absolute-link" href="/lottery/1"></Link>
                    <h4>02.</h4>
                    <div className="howToGetPoints-box-item-desc">参与抽奖中积分，还有Apple Watch等你拿</div>
                    <div className="howToGetPoints-box-item-link"><Link href="#">立即前往 ></Link></div>
                </Col>
                <Col span={8} className="howToGetPoints-box-item">
                    <h4>03.</h4>
                    <div className="howToGetPoints-box-item-desc">
                        <p>购买商品获取积分</p>
                        <p>每消费1元即可获取1积分</p>
                    </div>
                </Col>
            </Grid>
        </div>

# 秒杀推荐
FlashSaleBest = React.createClass
    render: ->
        <FlashSaleItem className="convert-goods bg-falsh-goods" data={this.props.data} />

# 秒杀单顶
FlashSaleItem = React.createClass
    render: ->
        self = this
        startDiff = moment( this.props.data.start_time ).diff( moment(), 'seconds')
        endDiff = moment( this.props.data.start_time ).diff( moment(), 'seconds')

        redirectToFlashSale = ->
            SP.redirect '/flashsale/' + self.props.data.sku_sn

        if startDiff > 0  # 即将开始
            actBtn = (
                <Button disabled={true} className="act-color-red" onTap={redirectToFlashSale} danger>即将开始</Button>
            )
            startTime = moment()
            endTime = this.props.data.start_time
        else
            # 秒杀期间
            if endDiff>0
                actBtn = (
                    <Button className="act-color-red" onTap={redirectToFlashSale} danger>立即秒杀</Button>
                )
                startTime = moment()
                endTime = this.props.data.end_time
            # 秒杀已结束
            else
                actBtn = (
                    <Button disabled={true} className="act-color-red" onTap={redirectToFlashSale} danger>已结束</Button>
                )
                startTime = this.props.data.end_time
                endTime = this.props.data.end_time

        <Grid cols={24} className="convert-goods bg-convert-goods" {...this.props}>
            <Col span={12} className="convert-goods-img">
                <Tappable onTap={redirectToFlashSale}>
                    <Img width="100%" src={this.props.data.img} />
                </Tappable>
            </Col>
            <Col span={12} className="convert-goods-info">
                <h3>{this.props.data.title}</h3>
                <div className="convert-goods-info-desc">
                    {this.props.data.desc}
                </div>
                <div className="convert-goods-info-price">
                    秒杀价：￥{this.props.data.price}
                </div>
                <div className="convert-goods-info-label">
                    原价：￥{this.props.data.basic_price}
                </div>
                <div className="convert-goods-info-label">
                    剩余时间：<CountDown key={this.props.data.id} data={{ startTime: startTime, endTime: endTime }} component={CountDownContent} />
                </div>
                <div className="convert-goods-info-sumbit">
                    {actBtn}
                </div>
            </Col>
        </Grid>

FlashSaleList = React.createClass
    render: ->
        <div className="act-flashsale-list">
            {this.props.data.map (item)->
                <FlashSaleItem key={item.id} className="convert-goods" data={item} />
            }
        </div>

# 秒杀
FlashSale = React.createClass
    handleSelected: (index, last)->
        #console.log('Selected tab: ' + index + ', Last tab: ' + last);
    render: ->

        #firstTime = moment().diff( moment('2015-07-20 00:00:00') , 'seconds');
        secondTime = moment().diff( moment('2015-07-23 00:00:00') , 'seconds');
        thirdTime = moment().diff( moment('2015-07-28 00:00:00') , 'seconds');

        if secondTime < 0
            selectedIndex  = 0
        else if secondTime > 0 and thirdTime < 0
            selectedIndex  = 1
        else if thirdTime > 0
            selectedIndex  = 2

        <div>
            <Tabs className="flashsale-tabs"
                onSelect={this.handleSelected}
                selectedIndex={selectedIndex}
            >
                <TabList>
                  <Tab>
                    <h4><em>3折</em>秒杀</h4>
                    <p>7.20-7.22</p>
                  </Tab>
                  <Tab>
                    <h4><em>1折</em>秒杀</h4>
                    <p>7.23-7.27</p>
                  </Tab>
                  <Tab>
                    <h4><em>1折</em>秒杀</h4>
                    <p>7.28-7.30</p>
                  </Tab>
                </TabList>

                <TabPanel>
                  <FlashSaleList data={@props.off70} />
                </TabPanel>
                <TabPanel>
                  <FlashSaleList data={@props.off80} />
                </TabPanel>
                <TabPanel>
                  <FlashSaleList data={@props.off90} />
                </TabPanel>

            </Tabs>
        </div>

# 视图
PageView = React.createClass
    mixins: [liteFlux.mixins.storeMixin(pageStore)]
    shareWeixinData: ->
        shareData =
            title: '抽奖赢取AppleWatch' # 分享标题
            desc: '赢取Apple Watch！快来参与斯品商城抽奖活动，100%中奖哦！'
            link: location.href
            imgUrl: 'http://7viii7.com2.z0.glb.qiniucdn.com/2015/07/15/a4c06ccc_apple-watch.png' # 分享图标
    componentDidMount: ->
        A('share').setShareData this.shareWeixinData()
        A('activity-july').getActivityData();
        document.getElementById('activity-page').onscroll = ->
            scroll_top =  document.getElementById('activity-page').scrollTop;
            if scroll_top >= 200
                document.getElementById('navbar-section').className = 'navbar bar-flexbox navbar_active';
            else
                document.getElementById('navbar-section').className = 'navbar bar-flexbox';
    componentWillUnmount: ->
        A('share').resetShareData();
    showPointsTips: ->

        alertComponent =
            <div className="act-rule-modal">
                <h3>兑换规则</h3>
                <div>
                    <p>1.礼品兑换成功后，我们将在15个工作日内进行发货；</p>
                    <p>2.会员兑换礼品数量不设上限，直至礼品被兑换完为止。</p>
                </div>
            </div>

        SP.alert {
            content: alertComponent,
            bsStyle: "red"
        }

    render: ->

        if @state[pageStore].data
            <Page className="activity-july-index">
                <Navbar id="navbar-section" transparent leftNavbar={<BackButton />}  rightNavbar={<HomeButton />}/>
                <PageContent className="bg-white" id="activity-page">
                    <div className="activity-july-header">
                        <img width="100%" src="../images/activity/1507/act-header.jpg" />
                    </div>
                    <AdBanner href={null} onTap={this.showPointsTips} bg={"../images/activity/1507/act-banner-01.jpg"} />
                    <Slide data={@state[pageStore].data.singleData} component={ConvertGoods} nav-right nav-gray></Slide>
                    <HowToGetPoints />
                    <AdBanner href={null} bg={"../images/activity/1507/act-banner-02.jpg"} />
                    <FlashSaleBest data={@state[pageStore].data.secKillData[0]} />
                    <FlashSale off70={@state[pageStore].data.off70} off80={@state[pageStore].data.off80} off90={@state[pageStore].data.off90} />
                    <AdBanner href={null} bg={"../images/activity/1507/act-banner-03.jpg"} />
                    <Slide data={@state[pageStore].data.bottomData} component={StarGoods}  nav-right nav-gray></Slide>
                </PageContent>
            </Page>
        else
            <Page className="activity-july-index">
                <Navbar id="navbar-section" transparent leftNavbar={<BackButton />} rightNavbar={<HomeButton />}/>
                <PageContent className="bg-white" id="activity-page">
                    <Loading />
                </PageContent>
            </Page>


module.exports = PageView;
