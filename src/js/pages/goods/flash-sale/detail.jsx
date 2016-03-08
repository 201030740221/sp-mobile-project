var React = require('react');
var Slide = require('components/lib/slider');
var Store = appStores.flashSale;
var CartStore = appStores.cart;
var FavoriteStore = appStores.favorite;
var GoodFooterNav = require('pages/goods/flash-sale/footer-nav');
var moment = require('moment');
var RegionBar = require('pages/goods/flash-sale/region-bar');

window.goods_id= 0;
var PageView = React.createClass({
    mixins: [liteFlux.mixins.storeMixin('flashsale')],
    componentDidMount: function () {
        liteFlux.action("flashsale").getGoodDetails(this.state.sku_sn);
        window.count = 1; /*默认数量*/
        // 微信分享
        var shareWeixinData = S("share").shareData;
        shareWeixinData.link = location.href;  // 分享链接
        A('share').setShareData(shareWeixinData);
    },
    getInitialState: function() {
        return {
            'sku_sn': this.props.id,
            'isFavorite': null
        };
    },
    componentWillReceiveProps: function(props) {
        liteFlux.action("flashsale").getGoodDetails(props.id);
        this.setState({
            'isFavorite': null
        });
    },
    favoriteHandle: function(goods_id,is_favorite){
        if(is_favorite){
            liteFlux.action("favorite").deleteGoodsFavorite(goods_id);
            this.setState({
                'isFavorite': false
            });

        }else{
            liteFlux.action("favorite").addGoodsFavorite(goods_id);
            this.setState({
                'isFavorite': true
            });
        }
    },
    componentWillUnmount: function () {
        A('flashsale').closeChannel();
        liteFlux.store("flashsale").reset();
        A('share').resetShareData();
    },
    renderAgreement: function(){
        return (
            <Panel>
                <p>1.提前设置收货信息：进入我的信息-收货信息-设置收货地址；</p>
                <p>2.秒杀开始时，按钮从"即将开始"变成"立即秒杀"，即可参与秒杀；</p>
                <p>3.点击"立即秒杀"后输入验证码并最终成功进入订单提交页表示秒杀成功；</p>
                <p>4.订单提交成功后，请务必在15分钟内完成付款，否则订单将被系统取消；</p>
                <p>5.此活动最终解释权归斯品家居商城所有。</p>
            </Panel>
        );
    },
    renderPhoneTips: function(){
        return (
            <Panel className="form">
                <Input type="text" ref='phone' placeholder="请输入你的手机号码" />
                <div className="u-mt-10">我们将会在活动当天秒杀前30分钟以短信的形式通知您</div>
            </Panel>
        );
    },
    // 未登录
    showLogin: function(){
        SP.loadLogin({
            success: function(){
                window.location.reload();
            }
        });
    },
    // 已登录
    showhasPhoneTips: function(e){
        e.preventDefault();
        e.stopPropagation();
        var begin_diff =  moment( S('flashsale').flashsale.begin_at ).subtract(1000*60*30).diff( moment(), 'seconds');

        if(S('flashsale').flashsale.mobile_bound){
            SP.message({
                msg: "您已经设置了手机提醒"
            });
        }else if(begin_diff<0){
            SP.message({
                msg: "手机提醒时间已结束"
            });
        }

    },
    // 设置手机通知
    addPhoneToClock: function(e){
        e.preventDefault();
        e.stopPropagation();
        return A('flashsale').addPhoneToClock(this.refs.phone.getValue(),function(res){

            SP.message({
                msg: res.msg
            });

        });
    },
    // 渲染秒杀通知视图
    showFlashTips:function(){
        var diff =  moment( S('flashsale').flashsale.begin_at ).subtract(1000*60*30).diff( moment(), 'seconds');
        var canSendSMS = diff<0 || S("flashsale").mobile_bound;
        var canSendSMSBtn = '';

        if( A("member").islogin() && !canSendSMS ){ // 已登录且未绑定手机
            canSendSMSBtn = (
                <Confirmable component={Button} block className="navbar-icon-index" bsStyle='primary' icon="alarm" contentElement={this.renderPhoneTips()} confirm={this.addPhoneToClock} margin={10} title="秒杀提醒设置" confirmText="确定" >秒杀提醒</Confirmable>
            );
        }else if(  A("member").islogin() && canSendSMS ) { // 已登录且绑定手机
            canSendSMSBtn = (
                <Button onTap={this.showhasPhoneTips} block className="navbar-icon-index" bsStyle='primary' icon="alarm">秒杀提醒</Button>
            );

        }else {  // 未登录
            canSendSMSBtn = (
                <Button onTap={this.showLogin} block className="navbar-icon-index" bsStyle='primary' icon="alarm">秒杀提醒</Button>
            );
        }

        if(this.state.flashsale.isFlash){
            return (
                <Grid className="falsh-sale-tips" cols={24}>
                    <Col span={12} className="u-text-center">
                        <Alertable component={Button} block className="navbar-icon-index" bsStyle='primary' icon="book" contentElement={this.renderAgreement()} margin={10} title="秒杀攻略" confirmText="朕知道了" >秒杀攻略</Alertable>
                    </Col>
                    <Col span={12} className="u-text-center">
                        {canSendSMSBtn}
                    </Col>
                </Grid>
            );
        }
    },
    render: function() {
        var data = this.state.flashsale.goodData || {}; /*商品信息*/
        var deliveryData = this.state.flashsale.delivery_price; /*物流信息*/
        if(data === undefined || data === null)
            return <Loading />;
        if(deliveryData === undefined || deliveryData === null)
            // return <Loading />;

        if(data.baseData === undefined || data.baseData === null)
            return <Loading />;
        goods_id = data.baseData.goods_id;
        var title  = data.baseData.title;
        /*slide img*/
        var slide_arr = [];
        for(var index in data.mediaData) {
            var slide_obj = { 'img': data.mediaData[index].full_path , 'url': '' };
            slide_arr.push(slide_obj);
        }

        var moreInfo = function(){
            if (sipinConfig.env === "production"){
                liteFlux.event.emit('click99',"click", "btn_more_info");
            }
        };

        return (
            <Page navbar-through toolbar-through>
                <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title = {title}></Navbar>
                <PageContent>
                    <div className="slide-section">
                        <Slide data={slide_arr} w={640}></Slide>
                    </div>
                    <GoodDetail flashsale={this.state.flashsale.flashsale} sku_sn = {this.state.sku_sn} item = { data } deliveryItem = {deliveryData}></GoodDetail>
                    <ListView className="member-index-menu u-mb-10">
                        <ListView.Item beforeAction={moreInfo} href={"/flashsale/detail/"+this.props.id} title="更多商品信息" />
                    </ListView>
                    {this.showFlashTips()}
                </PageContent>
                <Toolbar>
                    <GoodFooterNav fid={this.state.flashsale.flashsale.id} g_id = { data.baseData.goods_sku_id }></GoodFooterNav>
                </Toolbar>
            </Page>
        );
    }

});


/**
 * 商品详情
 */
var GoodDetail = React.createClass({
    componentDidMount: function () {

    },
    getCounter: function(current){
        count = current;
    },
    render: function() {
        var delivery = this.props.deliveryItem; /*物流*/
        var item = this.props.item.baseData;
        var skuData = this.props.item.skuData; /*规格和颜色*/
        var sku_arr1 = [];
        if(skuData[1]) {
            for (var index in skuData[1].value) {
                sku_arr1.push(skuData[1].value[index]);
            }
        }
        var sku_arr0 = [];
        if(skuData[0]) {
            for (var sku_arr0_index in skuData[0].value) {
                sku_arr0.push(skuData[0].value[sku_arr0_index]);
            }
        }
        return (
            <div className="good-detail-section">
                <div className="detail-dec-section">
                    <h3 className="mb10 u-f16"> { item.title } </h3>
                    <p className="mb10"> { item.subtitle } </p>
                    <Grid cols={24} className="good-title-p mb10">
                        <Col span={5} className="label-title">秒杀价:</Col>
                        <Col span={7} className="favourable—price"> ￥{ this.props.flashsale.price } </Col>
                        <Col span={5} className="label-title">原&nbsp;&nbsp;&nbsp;&nbsp;价:</Col>
                        <Col span={7}> ￥{ item.basic_price } </Col>
                    </Grid>
                </div>
                <div className="goods-dispatch-information-section flashsale-information-section-noborder">
                    <RegionBar sku_sn={this.props.sku_sn}></RegionBar>
                    <br />
                </div>
            </div>
        );
    }
});


module.exports = PageView;
