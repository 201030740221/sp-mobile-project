var React = require('react');
var Slide = require('components/lib/slider');
var timeManage = require('utils/time-manage');

var Store = appStores.website;
var CartStore = appStores.cart;
var moment = require('moment');
var PageGray = require('vendor/page-gray');
var Footer = require('./footer');


var BottomBanner = React.createClass({
    onClose: function(){
        S('website',{
            bannerShow: false
        });
    },
    render: function(){
        return (
            <div className="bottom-banner">
                <div className="bottom-banner-inner">
                    <Link className="bottom-banner-inner-link" href={"/activity/july"} />
                    <Link onTap={this.onClose} className="bottom-banner-inner-close" />
                    <img width="100%" src="../images/activity/1507/act-banner-home.png" />
                </div>
            </div>
        );
    }
});

var Year = new Date().getFullYear()


var PageView = React.createClass({
    mixins: [liteFlux.mixins.storeMixin('website')],
    componentDidMount: function() {
        liteFlux.action("website").getNewGoodsInformation();
/*scroll 交互处理*/
        document.getElementById('index-page').onscroll = function() {
            var scroll_top = document.getElementById('index-page').scrollTop;
            if (scroll_top >= 200) {
                document.getElementById('navbar-section').className = 'navbar bar-flexbox navbar_active';
            } else {
                document.getElementById('navbar-section').className = 'navbar bar-flexbox';
            }
        };
        // 首页变灰
        //PageGray.addGrayFilter();
    },
    componentWillUnmount: function() {
        // 其它页面回复变正常色
        //PageGray.removeGrayFilter();
    },
    getRecommendationData: function(data){
        //console.log(data);
        var result = [];
        if( data && data.position.length){
            data.position.map(function(_position){

                if(!_position.status)
                    return;

                var getBannerImg = function(){
                    switch (_position.type) {
                        case 1:
                            return _position.ad.attachment.media.full_path
                            break;
                        case 2:
                            return _position.recommendation.attachment?_position.recommendation.attachment.media.full_path:_position.recommendation.goods_sku.has_cover.media.full_path
                            break;

                    }
                }
                var getBannerUrl = function(){
                    switch (_position.type) {
                        case 1:
                            return _position.ad.ad_url
                            break;
                        case 2:
                            return '/item/' + _position.recommendation.goods_sku.sku_sn
                            break;

                    }
                }

                var getTitle = function(){
                    switch (_position.type) {
                        case 1:
                            return _position.ad.ad_title
                            break;
                        case 2:
                            return _position.recommendation.recommendation_title || _position.recommendation.goods_sku.goods.title
                            break;

                    }
                }

                var getDescription = function(){
                    switch (_position.type) {
                        case 1:
                            return _position.ad.ad_title
                            break;
                        case 2:
                            return _position.recommendation.recommendation_description || _position.recommendation.goods_sku.goods.subtitle
                            break;

                    }
                }

                var getPrice = function(){
                    switch (_position.type) {
                        case 1:
                            return null
                            break;
                        case 2:
                            return _position.recommendation.goods_sku.goods_sku_price.price
                            break;

                    }
                }

                var getGoodsSkuId = function(){
                    switch (_position.type) {
                        case 1:
                            return null
                            break;
                        case 2:
                            return _position.recommendation.goods_sku_id
                            break;
                    }
                }

                result.push({
                    'id':  _position.id,
                    'ad_type': _position.type,
                    'frame_id':_position.frame_id,
                    'ad_id':  _position.id,
                    'img': getBannerImg(),
                    'url': getBannerUrl(),
                    'title': getTitle(),
                    'description': getDescription(),
                    'price': getPrice(),
                    'goods_sku_id': getGoodsSkuId()
                })
            });

        }
        return result;
    },
    render: function() {
        /*接收数据*/
        if (this.state.website === undefined || this.state.website === null)
            return <Loading/>;

        /*slider 要传入的数据*/
        var slide_arr = this.getRecommendationData(this.state.website.banner);

        /*新品 数据处理*/
        var data_arr = this.getRecommendationData(this.state.website['new-arrival']);

        var BottomBannerDom = '';
        if(timeManage.before('2015-08-01 00:00:00')){
            BottomBannerDom = (<BottomBanner />);
        }

        return (
            <Page className="website-index">
                <Navbar id="navbar-section" title="斯品家居" style={{background: 'rgba(219, 174, 138, 0.9)',color: '#fff',fontWeight:'normal'}} transparent leftNavbar={<MenuIcon />} rightNavbar={<IndexRightIcon />} />
                {BottomBannerDom}
                <PageContent className="bg-white" id="index-page">
                    <div>
                        <Slide banner data={slide_arr} nav-center nav-gold w={640}></Slide>
                        <h2 className="index-title-content" id="title-section">
                            每周新品
                            <span className="sub-title">WEEKLY NEW</span>
                        </h2>
                        <IndexList data={data_arr}></IndexList>
                        <ClassifyEnter/>
                        <Footer />
                    </div>
                </PageContent>
                <LiteCart/>
            </Page>
        );
    }
});

/**
 * menu icon
 */
var MenuIcon = React.createClass({
    onJumpMenu: function() {
        // 99click 首页侧栏统计
        if (sipinConfig.env === "production"){
            liteFlux.event.emit('click99',"click", "btn_menu_home");
        }
        SP.redirect('/category/view/list');
    },
    render: function() {
        return (
            <Button bsStyle='icon' className="navbar-icon-index" icon="menu" onTap={this.onJumpMenu}></Button>
        );
    }
});

/**
 * index right icon
 */
var IndexRightIcon = React.createClass({
    onJumpMemberCenter: function() {
        // 99click 用户中心统计
        if (sipinConfig.env === "production"){
            liteFlux.event.emit('click99',"click", "btn_userinfo");
        }
        SP.redirect('/member');
    },
    onSearch: function() {
        SP.redirect('/category/view/search');
    },
    render: function() {
        return (
            <div>
                <Button bsStyle='icon' className="navbar-icon-index u-mr-10" icon="searsh" onTap={this.onSearch}></Button>
                <Button bsStyle='icon' className="navbar-icon-index" icon="center" onTap={this.onJumpMemberCenter}></Button>
            </div>
        );
    }
});

/**
 * index list
 */
var IndexList = React.createClass({
    render: function() {
        var list = this.props.data;
        var $ItemNode = list.map(function(item) {
            return (
                <ListItem item={item} key={item.id}></ListItem>
            );
        });
        return (
            <div>
                <ul className="index-list">
                    {$ItemNode}
                </ul>
            </div>
        );
    }
});

/**
 * list item
 */
var ListItem = React.createClass({
    addToCart: function() {
        var goods_sku_id = this.props.item.goods_sku_id,
            goods_sku_quantity = 1;
        liteFlux.action("cart").addToCart(goods_sku_id, goods_sku_quantity);
    },
    render: function() {

        var item = this.props.item;
        if(!item){
            return false;
        }
        return (
            <li>
                <Link href={item.url}><Img alt="" src={item.img} w={640}/></Link>
                <div className="information">
                    <h4>
                        <Link href={item.url}>{item.title}</Link>
                        <span className="price">￥{item.price}</span>
                    </h4>
                    <p>{item.description}</p>
                    <div className="list-cart-btn icon icon-addition">
                        <AddToCart>
                            <Tappable onTap={this.addToCart}>购物车</Tappable>
                        </AddToCart>
                    </div>
                </div>
            </li>
        );
    }
});

/**
 * 首页分类入口
 */
var ClassifyEnter = React.createClass({
    render: function() {
        // 99click 统计分类点击
        var bedRoomClick = function(){
            if (sipinConfig.env === "production"){
                liteFlux.event.emit('click99',"click", "btn_bedroom");
            }
        };

        // 99click 统计分类点击
        var livingRoomClick = function(){
            if (sipinConfig.env === "production"){
                liteFlux.event.emit('click99',"click", "btn_livingroom");
            }
        };

        // 99click 统计分类点击
        var diningRoomClick = function(){
            if (sipinConfig.env === "production"){
                liteFlux.event.emit('click99',"click", "btn_diningroom");
            }
        };

        // 99click 统计分类点击
        var studyoomClick = function(){
            if (sipinConfig.env === "production"){
                liteFlux.event.emit('click99',"click", "btn_studyroom");
            }
        };


        return (
            <div>
                <div className="classify-list">
                    <div className="classify-item">
                        <Link beforeAction={bedRoomClick} href="/category/6"><img alt="" src="../images/bed-icon.png"/>
                            <i className="icon-font-content icon icon-bed"/>
                            <p>
                                卧室</p>
                        </Link>
                    </div>
                    <div className="classify-item">
                        <Link beforeAction={livingRoomClick} href="/category/2">
                            <img alt="" src="../images/sofa-icon.png"/><i className="icon-font-content icon icon-sofa"/>
                            <p>客厅
                            </p>
                        </Link>
                    </div>
                </div>
                <div className="classify-list">
                    <div className="classify-item">
                        <Link beforeAction={diningRoomClick} href="/category/9">
                            <img alt="" src="../images/dining-icon.png"/>
                            <i className="icon-font-content icon icon-diningtable"/>
                            <p>
                                餐厅</p>
                        </Link>
                    </div>
                    <div className="classify-item">
                        <Link beforeAction={studyoomClick} href="/category/19">
                            <img alt="" src="../images/soho-icon.png"/>
                            <i className="icon-font-content icon icon-soho"/>
                            <p>书房
                            </p>
                        </Link>
                    </div>
                </div>
            </div>
        );
    }
});

module.exports = PageView;
