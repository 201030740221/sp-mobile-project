var React = require('react');
var Slide = require('components/lib/slider');
var timeManage = require('utils/time-manage');

var Store = appStores.website;
var activityNovemberStore = appStores.activityNovember;

var moment = require('moment');

var this_i = 0;
var Year = new Date().getFullYear();
var Month = new Date().getMonth();
var Day = new Date().getDate();
var Hours = new Date().getHours();
var Minutes = new Date().getMinutes();
var Seconds = new Date().getSeconds();

if (Day < 6) {
    Day = 6;
} else if (Day > 13) {
    Day = 13;
}


var PageView = React.createClass({
    getDefaultProps: function(){
        return {
            shareUrl: window.location.href
        }

    },
    getInitialState: function(){
        var menberData = S('member');
        return {
            couponSource: {},
            mobile: menberData.mobile,
            bannerImg: { url: '../images/activity/take-off/banner.jpg' },
            couponImg: { url: '../images/activity/take-off/coupon.jpg' },
            titleImg: { url: '../images/activity/take-off/title-img.jpg'},
            insaneImg: { url: '../images/activity/take-off/insane.jpg'},
            bgInsaneImg: { url: '../images/activity/take-off/bg-insane.jpg'},
            fullCutImg: { url: '../images/activity/take-off/full-cut.jpg'},
            fullCouponImg: { url: '../images/activity/take-off/full-coupon.jpg'},
            footerShapeImg: { url: '../images/activity/take-off/footer-shape.png'},

            navList: [
                { id: 1, title: '领优惠券', class_active: '' },
                { id: 2, title: '秒杀',     class_active: '' },
                { id: 3, title: '一口价' ,  class_active: '' },
                { id: 4, title: '满减区' ,  class_active: '' },
                { id: 5, title: '满折区' ,  class_active: '' }
            ],
            navClass: 'activity-nav',

            seckillData: [
                { day: 6,  img: [ {url:'', title:'', price:'', kill_price:''} ] },
                { day: 7,  img: [ {url:'', title:'', price:'', kill_price:''} ] },
                { day: 8,  img: [ {url:'', title:'', price:'', kill_price:''} ] },
                { day: 9,  img: [ {url:'', title:'', price:'', kill_price:''} ] },
                { day: 10, img: [ {url:'', title:'', price:'', kill_price:''} ] },
                { day: 11, img: [ {url:'', title:'', price:'', kill_price:''} ] },
                { day: 12, img: [ {url:'', title:'', price:'', kill_price:''} ] },
                { day: 13, img: [ {url:'', title:'', price:'', kill_price:''} ] }
            ],

            activitySku: {},
            flashSalesArr: [],
            showFlashSales: [],

            timer: null,

            server_time: ''

        }
    },

    countDown: function(){
        var self = this;
        clearInterval(this.state.timer);
        this.setState({
            timer: setInterval(function() {
                self.setShowFlashSales();
            }, 1000)
        });
    },

    handleFlashStatus: function(server_time,item){

        var begintime = +moment(item.begin_at);
        var endtime = +moment(item.end_at);
        var servertime = +moment(server_time);

        if(item.id && servertime > begintime && servertime < endtime){
            var request_data = {
                flash_sale_id: item.id
            };
            liteFlux.action("activity-november").getFlashSaleStatus(request_data,function(this_data){

                var status = this_data.status;

                if(status) {

                    item.dec_title = '正在秒杀中';
                    item.coming = '';
                    item.coming_price = '';
                    item.now_btn = ''
                    item.showNode = true;

                } else {

                    item.dec_title = '秒杀已结束';
                    item.coming = 'end';
                    item.coming_price = 'end-price';
                    item.now_btn = 'end-btn';
                    item.showNode = false;

                }

            })
        }
    },


    componentDidMount: function() {
        var _this = this;
        liteFlux.action("activity-november").getActivityCoupon({},function(data){
            _this.setState({
                couponSource: data
            })
        });

        var seckillData = this.state.seckillData;
        for(var key in seckillData){
            if(seckillData[key].day==Day){
                seckillData[key].active = 'day_active'
            }else{
                seckillData[key].active = ''
            }
        }
        this.setState({
            seckillData: seckillData
        });

        /*商品信息*/
        liteFlux.action("activity-november").getNovemberSecond({},function(data){

            _this.setState({
                activitySku: data
            });

            _this.setState({
                server_time: data.server_time
            })
            /*日期數據處理*/
            var flashSales = data.flashSales || [];
            var flashSales_arr = [];

            flashSales.forEach(function(item,key){

                var begintime = +moment(item.begin_at);
                var endtime = +moment(item.end_at);
                var servertime = +moment(data.server_time);

                var this_obj = item;

                this_obj.dec_title = new Date(begintime).getHours() + ':00进行秒杀';
                this_obj.coming = 'coming';
                this_obj.coming_price = 'coming-price';
                this_obj.now_btn = 'now-btn';
                this_obj.showNode = true;

                if(servertime > begintime) {
                    this_obj.dec_title = '正在秒杀中';
                    this_obj.coming = '';
                    this_obj.coming_price = '';
                    this_obj.now_btn = ''
                    this_obj.showNode = true;
                }
                if(servertime > endtime) {
                    this_obj.dec_title = '秒杀已结束';
                    this_obj.coming = 'end';
                    this_obj.coming_price = 'end-price';
                    this_obj.now_btn = 'end-btn';
                    this_obj.showNode = false;
                }


                flashSales_arr.push(this_obj);

            });

            _this.setState({
                flashSalesArr: flashSales_arr
            });

            /*設置當前時間的秒殺*/
            var this_date_arr = [];
            flashSales_arr.forEach(function(item,key){
                var begintime = +moment(item.begin_at);
                var begin_day = new Date(begintime).getDate();
                if(begin_day==Day){
                    /*请求秒杀状态*/
                    _this.handleFlashStatus(data.server_time,item);
                    this_date_arr.push(item);
                }
            });
            _this.setState({
                showFlashSales: this_date_arr
            })
        });

       // this.countDown();
    },

    componentWillReceiveProps: function(){
        //this.countDown();
    },
    componentWillUnmount: function() {

    },

    /*自动监测时间*/
    setShowFlashSales: function(){
        var showFlashSales = this.state.showFlashSales;

        for(var key in showFlashSales){
            showFlashSales[key].log = this_i++;
        }
        this.setState({
            showFlashSales: showFlashSales
        })
    },

    navActiveHandle: function(id,navList){/*设置active*/
        var _this =this;
        for(var key in navList){
            if(navList[key].id==id){
                navList[key].class_active = 'active';
            }else{
                navList[key].class_active = '';
            }
        }
        _this.setState({
            navList :  navList
        });
    },

    componentDidUpdate: function(){

        var _this = this;
        var navList = this.state.navList;
        var coupon_top = document.getElementById('coupon').offsetTop,
            seckill_top = document.getElementById('seckill').offsetTop,
            insane_top = document.getElementById('insane').offsetTop,
            full_cut_top = document.getElementById('full-cut').offsetTop,
            full_coupon_top = document.getElementById('full-coupon').offsetTop;

        document.getElementById('index-page').onscroll = function() {
            var scroll_top = document.getElementById('index-page').scrollTop;
            /*console.log(scroll_top);*/

            if (scroll_top >= coupon_top-54) {/*显示导航*/
                _this.setState({
                    navClass: 'activity-nav active'
                });

                if(scroll_top < seckill_top-54){
                    _this.navActiveHandle(1,navList);
                }

                if(scroll_top >= seckill_top-54 && scroll_top < insane_top-54){
                    _this.navActiveHandle(2,navList);
                }

                if(scroll_top >= insane_top-54 && scroll_top < full_cut_top-54){
                    _this.navActiveHandle(3,navList);
                }

                if(scroll_top >= full_cut_top-54 && scroll_top < full_coupon_top-54){
                    _this.navActiveHandle(4,navList);
                }
                if(scroll_top >= full_coupon_top-54){
                    _this.navActiveHandle(5,navList);
                }

            } else {
                _this.setState({
                    navClass: 'activity-nav'
                });
            }
        };
    },

    /*点击nav*/
    navClickHandle: function(id){
        var _this = this;
        var navList = this.state.navList;
        var coupon_top = document.getElementById('coupon').offsetTop,
            seckill_top = document.getElementById('seckill').offsetTop,
            insane_top = document.getElementById('insane').offsetTop,
            full_cut_top = document.getElementById('full-cut').offsetTop,
            full_coupon_top = document.getElementById('full-coupon').offsetTop;

        this.navActiveHandle(id,navList);

        if(id==1){
            document.getElementById('index-page').scrollTop = coupon_top-54;
        }
        if(id==2){
            document.getElementById('index-page').scrollTop = seckill_top-54;
        }
        if(id==3){
            document.getElementById('index-page').scrollTop = insane_top-54;
        }
        if(id==4){
            document.getElementById('index-page').scrollTop = full_cut_top-54;
        }
        if(id==5){
            document.getElementById('index-page').scrollTop = full_coupon_top-54;
        }
    },
    ActivityNavNode: function(){
        var _this = this;
        var navList = this.state.navList;
        var _this_node = (
            <div id='activity-nav-section' className={this.state.navClass}>
                {
                    navList.map(function(item,key){
                        return (
                            <div key={key}>
                                <Tappable className={"activity-link "+item.class_active} onTap={_this.navClickHandle.bind(null,item.id)}>{item.title}</Tappable>
                            </div>
                        )
                    })
                }
            </div>
        );
        return _this_node
    },

    /*优惠券*/
    couponHandle: function(coupon_id,title,content){
        var text_content = <span>您可以在<span style={{color:'#fa6400'}}>个人中心-我的优惠券</span>中查看</span>
        liteFlux.action("activity-november").getCoupon(coupon_id,title,content,text_content);
    },
    CouponImgNode: function(){

        var _this = this;
        var couponImg = this.state.couponImg;

        var couponSource = this.state.couponSource,
            coupon_ids = couponSource.coupon_ids || [];
        var couponArr = [
            { id: coupon_ids[4], value: 20 , content: '20元现金券' },
            { id: coupon_ids[0], value: 1000 , content: '满1000减120' },
            { id: coupon_ids[1], value: 2000 , content: '满2000减200' },
            { id: coupon_ids[2], value: 300 , content: '满300享9折' },
            { id: coupon_ids[3], value: 500 , content: '满500享8折' }
        ];
        var _this_node = '';

        /*if(Year==2015 && Month==10 && Day>=3){*/
        _this_node = (
            <div id='coupon' style={{position:'relative'}}>
                <Img alt="" src={couponImg.url} w={640} width='100%'/>
                <div className='coupon-link-content'>
                    <Tappable className='coupon-link'></Tappable>
                    {
                        couponArr.map(function(item,key){
                            var title = <span>已成功领取<span style={{color:'#cc2a1e'}}>{item.content}</span>优惠券</span>
                            item.title = title
                            return (
                                <Tappable className='coupon-link' onTap={_this.couponHandle.bind(null,item.id,item.title,item.content)} key={key}></Tappable>
                            )
                        })
                    }
                </div>
            </div>
        );
        /* }*/

       return _this_node;
    },

    /*秒杀*/
    warnHandle: function(){
        var title = <span>上<span style={{color:'#fa6400'}}>sipin.com</span>购买卧室八件套！</span>
        SP.alert({
            title: title,
            confirmText: '知道啦',
            showCloseIcon: false,
            bsStyle: 'red'
        });
    },
    dateClickHandle: function(day){
        var _this = this;

        var flashSalesArr = this.state.flashSalesArr,
            showFlashSales = this.state.showFlashSales,
            seckillData = this.state.seckillData;
        var server_time = this.state.server_time;

        for(var key in seckillData){
            if(+(seckillData[key].day)==day){
                seckillData[key].active = 'day_active';
            }else{
                seckillData[key].active = '';
            }
        }

        var _this_arr = [];
        flashSalesArr.forEach(function(item,key){
            var begintime = +moment(item.begin_at);
            var begin_day = new Date(begintime).getDate();
            if(begin_day==day){

                /*请求秒杀状态*/
                 _this.handleFlashStatus(server_time,item);
                _this_arr.push(item);

            }
        });

        this.setState({
            seckillData: seckillData,
            showFlashSales: _this_arr
        })

    },
    seckillNode: function(){

        var _this = this;
        var seckillData = this.state.seckillData;
        var showFlashSales = this.state.showFlashSales;

        var _this_node = (
            <div id='seckill'>
                <div className='title-img-section'>
                    <Tappable onTap={this.warnHandle}><Img alt="" src={this.state.titleImg.url} w={640} width='100%'/></Tappable>
                </div>
                <div className='seckill-section'>
                    <div className="seckill-goods-content">
                        <div className="nav-section">
                            <ul className='nav-ul'>
                                {
                                    seckillData.map(function(item,key){
                                        return (
                                            <li className={item.active} key={key}>
                                                <Tappable onTap={_this.dateClickHandle.bind(null,item.day)} style={{display:'inline-block',width:'100%',height:'100%'}}>{item.day}日</Tappable>
                                            </li>
                                        )
                                    })
                                }
                            </ul>
                        </div>

                        {
                            showFlashSales.map(function(item,key){

                                var goodsSku = item.goodsSku || {};
                                var url = '';
                                if(goodsSku.has_cover){
                                    url = goodsSku.has_cover.media.full_path;
                                }

                                var flashNodeBtn = (
                                    <Link href={"/flashsale/"+goodsSku.sku_sn}><p className={"dec-btn "+item.now_btn}>立即抢购</p></Link>
                                );
                                if(item.showNode){
                                    flashNodeBtn = (
                                        <Link href={"/flashsale/"+goodsSku.sku_sn}><p className={"dec-btn "+item.now_btn}>立即抢购</p></Link>
                                    );
                                }else{
                                    flashNodeBtn = (
                                        <p className={"dec-btn "+item.now_btn}>已结束</p>
                                    );
                                }
                                return (
                                    <div className="goods-list" key={key}>
                                        <div className="dec-content">
                                            <Img src={url} alt="" w={640} width='100%'/>
                                        </div>
                                        <div className="dec-content">
                                            <p className={"dec-warning "+item.coming}>{item.dec_title}</p>
                                            <p className="dec-title">{goodsSku.goods.title} </p>
                                            <p className="dec-price">原价:￥{goodsSku.basic_price}</p>
                                            <p className='other-shape'></p>
                                            <div className={"shape-warn "+item.coming_price}>
                                                <p>秒杀价</p>
                                                <p className='_this-price'>￥{item.price}</p>
                                            </div>
                                           {flashNodeBtn}
                                        </div>
                                    </div>
                                )
                            })
                        }

                    </div>
                </div>
            </div>
        );
        return _this_node
    },

    /*一口价*/
    InsaneNode: function(){

        var _this = this,
            activitySku = this.state.activitySku,
            fixedPriceSkus = activitySku.fixedPriceSkus || [];

        var _this_node = (
            <div id='insane' className="insane">
                <Img alt="" src={this.state.insaneImg.url} w={640} width='100%'/>
                <div className="bg-insane" style={{marginTop:'-54'}}>
                    <div className="content">
                        <div className="section">
                            {
                                fixedPriceSkus.map(function(item,key){

                                    var url = '';
                                    if(item.has_cover){
                                        url = item.has_cover.media.full_path;
                                    }

                                    return (
                                        <div className="list" key={key}>
                                            <div className='img-content'>
                                                <Img src={url} alt="" w={640} width='100%'/>
                                            </div>
                                            <div className="section-dec">
                                                <div className="dec-title">
                                                    <p> {item.goods.title} </p>
                                                    <p>原价:￥{item.basic_price}</p>
                                                </div>
                                                <Link href={"/item/"+item.sku_sn}><div className="dec-price">一口价:￥{item.price}</div></Link>
                                            </div>
                                        </div>
                                    )
                                })
                            }
                        </div>
                    </div>

                </div>
            </div>
        );
        return _this_node
    },

    /*抢满减*/
    FullCutNode: function(){

        var _this = this,
            activitySku = this.state.activitySku,
            reduceSkus = activitySku.reduceSkus || [];

        var _this_node = (
            <div id='full-cut' className='full-cut-section'>
                <Img alt="" src={this.state.fullCutImg.url} w={640} width='100%'/>
                <div className="bg-insane">
                    <div className="content">
                        <div className="section">
                            {
                                reduceSkus.map(function(item,key) {

                                    var url = '';
                                    if (item.has_cover) {
                                        url = item.has_cover.media.full_path;
                                    }
                                    return (
                                        <div className="list" key={key}>
                                            <div className='img-content'>
                                                <Img src={url} alt="" w={640} width='100%'/>
                                            </div>
                                            <div className="section-dec">
                                                <div className="dec-title">
                                                    <p> {item.goods.title} </p>
                                                    <p>原价:￥{item.basic_price}</p>
                                                </div>
                                                <Link href={"/item/"+item.sku_sn}><div className="dec-price full-cut">马上抢购</div></Link>
                                            </div>
                                        </div>
                                    )
                                })
                            }
                        </div>
                    </div>
                </div>
            </div>
        );
        return _this_node
    },

    /*抢满折*/
    FullCouponNode: function(){

        var _this = this,
            activitySku = this.state.activitySku,
            discountSkus = activitySku.discountSkus || [];

        var _this_node = (
            <div id='full-coupon' className='full-coupon-section'>
                <Img alt="" src={this.state.fullCouponImg.url} w={640} width='100%'/>
                <div className="bg-insane">
                    <div className="content">
                        <div className="section">
                            {
                                discountSkus.map(function(item,key) {

                                    var url = '';
                                    if (item.has_cover) {
                                        url = item.has_cover.media.full_path;
                                    }
                                    return (
                                        <div className="list" key={key}>
                                            <div className='img-content'>
                                                <Img src={url} alt="" w={640} width='100%'/>
                                            </div>
                                            <div className="section-dec">
                                                <div className="dec-title">
                                                    <p> {item.goods.title} </p>
                                                    <p>原价:￥{item.basic_price}</p>
                                                </div>
                                                <Link href={"/item/"+item.sku_sn}><div className="dec-price full-coupon">马上抢购</div></Link>
                                            </div>
                                        </div>
                                    )
                                })
                            }
                        </div>
                    </div>
                </div>
            </div>
        );
        return _this_node
    },

    render: function() {

        var title = '活动预告';

        return (
            <Page className="website-index">
                <Navbar leftNavbar={<BackButton />}  title = {title}></Navbar>

                {this.ActivityNavNode()}

                <PageContent className="bg-white" id="index-page">
                    <div className='banner-section'>
                        <Img alt="" src={this.state.bannerImg.url} w={640} width='100%'/>
                    </div>

                    {this.CouponImgNode()}
                    {this.seckillNode()}
                    {this.InsaneNode()}
                    {this.FullCutNode()}
                    {this.FullCouponNode()}

                    <div className='footer-shape-section'>
                        <Img alt="" src={this.state.footerShapeImg.url} w={640} width='100%'/>
                    </div>
                    <div>
                        <div className="index-footer">
                            <span>
                                Copyright &copy; {Year} 斯品sipin.com 版权所有
                            </span>
                        </div>
                    </div>
                </PageContent>
                <LiteCart/>
            </Page>
        );
    }
});

module.exports = PageView;