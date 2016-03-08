var React = require('react');
var Slide = require('components/lib/slider');

var Store = appStores.goodDetail;
var Action = Store.getAction();
var CartStore = appStores.cart;
var FavoriteStore = appStores.favorite;

var GoodFooterNav = require('pages/goods/detail/footer-nav');
var RegionBar = require('pages/goods/detail/region-bar');
var timeManage = require('utils/time-manage');

window.goods_id= 0;
var PageView = React.createClass({
    mixins: [liteFlux.mixins.storeMixin('detail','favorite')],
    componentDidMount: function () {
        liteFlux.action("detail").getGoodDetails(this.state.sku_sn);
        // window.count = 1; /*默认数量*/
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
        liteFlux.action("detail").getGoodDetails(props.id);
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

            if (sipinConfig.env === "production"){
                liteFlux.event.emit('click99',"click", "unfavorite");
            }

        }else{
            liteFlux.action("favorite").addGoodsFavorite(goods_id);
            this.setState({
                'isFavorite': true
            });

            if (sipinConfig.env === "production"){
                liteFlux.event.emit('click99',"click", "collect");
            }
        }
    },
    componentWillUnmount: function () {
        //liteFlux.store("detail").reset();
        A('share').resetShareData();
    },
    render: function() {
        var data = this.state.detail.goodData || {}; /*商品信息*/
        var deliveryData = this.state.detail.delivery_price; /*物流信息*/

        // if(deliveryData === undefined || deliveryData === null)
        //     // return <Loading />;

        if(data.baseData === undefined || data.baseData === null) {
            return <Loading />;
        }
        goods_id = data.baseData.goods_id;
        var title  = data.baseData.title;
        /*slide img*/
        var slide_arr = [];
        for(var index in data.mediaData) {
            var slide_obj = { 'img': data.mediaData[index].full_path , 'url': '' };
            slide_arr.push(slide_obj);
        }

        /*收藏处理*/
        var is_favorite = this.state.isFavorite;
        if(is_favorite === null || is_favorite === undefined){
            is_favorite = data.is_favorite;
        }
        var favorite_classes = '';

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
                        <Tappable className={favorite_classes} onTap={this.favoriteHandle.bind(null,goods_id,is_favorite)}></Tappable>
                    </div>
                    <GoodDetail sku_sn = {this.state.sku_sn} item = { data } deliveryItem = {deliveryData}></GoodDetail>
                    <ListView className="member-index-menu u-mb-10">
                        <ListView.Item beforeAction={moreInfo} href={"/more-item/"+this.props.id} title="更多商品信息" />
                        <ListView.Item beforeAction={moreInfo} href={"/item/"+this.props.id+"/comment"} title={<span>评价晒单（<span className="u-color-red">{data.baseData.comment_count}</span>）</span>} />
                    </ListView>
                </PageContent>
                <Toolbar>
                    <GoodFooterNav g_id = { data.baseData.goods_sku_id }></GoodFooterNav>
                </Toolbar>
            </Page>
        );
    }

});


/**
 * 商品详情
 */
var GoodDetail = React.createClass({
    mixins:[ModulesMixins.goodsSkuSelector],
    componentDidMount: function () {

    },
    getCounter: function(current){
        Action.updateQuantity(current);
    },
    getPromotion: function (goods) {
        /*
            TODO 2015-11-13之前显示促销
         */
        // remissionGoods 满减商品goods id
        // discountGoods 满折商品goods id
        //
        if (!timeManage.before('2015-11-13 16:00:00')) {
            return null
        }

        var remissionGoods = [190,161,159,174,123,115,198,131,165,148,206,202,7,105,81,68,120,98,82,141,142,145,150,40]
        ,   discountGoods = [197,205,201,195,156,170,183,176,178,154,155,152]
        ,   link = '/activity/novemberTakeOff'
        ,   goodsId = goods.id
        ,   type = null

        ,   promoes = [{
            type: 'discount',
            title: '11月活动家纺满300享9折',
            link: link
        }, {
            type: 'discount',
            title: '11月活动家纺满500享8折',
            link: link
        }, {
            type: 'remission',
            title: '11月活动家具满1000减180',
            link: link
        }, {
            type: 'remission',
            title: '11月活动家具满2000减300',
            link: link
        }];

        if (remissionGoods.indexOf(goodsId) != -1) {
            type = 'remission'
        } else if (discountGoods.indexOf(goodsId) != -1) {
            type = 'discount'
        }

        if (!type) {
            return null
        }

        var goodsPromos = promoes.filter(function (promo) {
            return promo.type === type
        });

        return (
            <Grid cols={24} className="label-list mb10">
                <Col span={5} className="label-title">促&nbsp;&nbsp;&nbsp;&nbsp;销:</Col>
                <Col span={18}>
                    {
                        goodsPromos.map(function(promo) {
                            var promoClass = 'discount';

                            if (promo.type === 'remission') {
                                promoClass += ' remission';
                            }

                            return (
                                <div className="promotion">
                                    <span className={ promoClass }></span>
                                    <span className="promo-title">{ promo.title }</span>
                                    <Link component="a" href={promo.link}>活动详情》</Link>
                                </div>
                            )
                        })
                    }
                </Col>
            </Grid>
        )

        return
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

        var installationClasses = deliveryClasses = "basic_installation";

        if(timeManage.before('2015-11-13 16:00:00')){
            installationClasses = deliveryClasses = "basic_installation del-line";
        }
        price_node = (
            <Grid cols={24} className="good-title-p mb10">
                <Col span={5} className="label-title">价&nbsp;&nbsp;&nbsp;&nbsp;格:</Col>
                <Col span={7} className="favourable—price"> ￥{ item.price } </Col>
                <Col span={5} className="label-title"></Col>
                <Col span={7}></Col>
            </Grid>
        )
        if(+item.basic_price != +item.price){
            price_node = (
                <Grid cols={24} className="good-title-p mb10">
                    <Col span={5} className="label-title">特&nbsp;&nbsp;&nbsp;&nbsp;惠:</Col>
                    <Col span={7} className="favourable—price"> ￥{ item.price } </Col>
                    <Col span={5} className="label-title">原&nbsp;&nbsp;&nbsp;&nbsp;价:</Col>
                    <Col span={7}> ￥{ item.basic_price } </Col>
                </Grid>
            )
        }

        // <Grid cols={24} className="label-list">
        //     <Col span={5} className="label-title">运{'\u00A0\u00A0\u00A0\u00A0'}费:</Col>
        //     <Col span={7} className={deliveryClasses}> ￥{ delivery !== undefined?delivery.toFixed(2):''} </Col>
        //     <Col span={5} className="label-title">安装费:</Col>
        //     <Col span={7} className={installationClasses}> ￥{ item.basic_installation } </Col>
        // </Grid>
        return (
            <div className="good-detail-section">
                <div className="detail-dec-section">
                    <h3 className="mb10 u-f16"> { item.title } </h3>
                    <p className="mb10"> { item.subtitle } </p>
                    {price_node}
                    { this.getPromotion(item) }
                </div>
                <div className="goods-dispatch-information-section">
                    <RegionBar sku_sn={this.props.sku_sn}></RegionBar>
                    <br />
                </div>
                <div className="number-content">
                    {this.renderSku()}
                    <Grid cols={24} className="label-list">
                        <Col span={5} className="label-title">数&nbsp;&nbsp;&nbsp;&nbsp;量:</Col>
                        <Col span={19}>
                            <Counter callback={this.getCounter} current={S('detail').quantity}></Counter>
                        </Col>
                    </Grid>
                </div>
            </div>
        );
    }
});


module.exports = PageView;
