var React = require('react');
var Slide = require('components/lib/slider');
var timeManage = require('utils/time-manage');

var Store = appStores.website;
var activityNovemberStore = appStores.activityNovember;

var moment = require('moment');


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

var Year = new Date().getFullYear();
var Month = new Date().getMonth();
var Day = new Date().getDate();


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
            couponImg: { url: '../images/activity/2015-11/coupon.jpg' },
            banner: { url: '../images/activity/2015-11/banner.jpg?v2'},
            adImgUrl : [
                {url:'../images/activity/2015-11/ad-pic1.jpg'},
                {url:'../images/activity/2015-11/ad-pic2.jpg'},
                {url:'../images/activity/2015-11/ad-pic3.jpg'},
                {url:'../images/activity/2015-11/ad-pic4.jpg'}
            ],
            slideImg: [
                { img: '../images/activity/2015-11/slide-01.jpg' },
                { img: '../images/activity/2015-11/slide-02.jpg' },
                { img: '../images/activity/2015-11/slide-03.jpg' },
                { img: '../images/activity/2015-11/slide-04.jpg' },
                { img: '../images/activity/2015-11/slide-05.jpg' },
                { img: '../images/activity/2015-11/slide-06.jpg' }
            ],
            footerImg: [
                {url:'../images/activity/2015-11/lotty-pic.jpg'},
                {url:'../images/activity/2015-11/return-pic.jpg'}
            ],
            mobile: menberData.mobile,

            november_second_activity: '/activity/novemberTakeOff'
        }
    },
    componentDidMount: function() {
        var _this = this;
        liteFlux.action("activity-november").getActivityCoupon({},function(data){
            _this.setState({
                couponSource: data
            })
        });
    },
    componentWillUnmount: function() {

    },
    shareWeiboData: function(){
        var shareData = {
            title: '约惠斯品，用心爱家',
            desc: '整个11月，找茬赢大奖、一元秒杀、抽奖多场活动等你参加。',
            link: this.props.shareUrl,
            imgUrl: 'http://7sbwdf.com2.z0.glb.qiniucdn.com/55c0667d7b264_lottery.jpg'
        };

        return shareData
    },
    shareWeixinData: function(){
        var shareData = {
            title: '约惠斯品，用心爱家',
            desc: '整个11月，找茬赢大奖、一元秒杀、抽奖多场活动等你参加。',
            link: this.props.shareUrl,
            imgUrl: 'http://7sbwdf.com2.z0.glb.qiniucdn.com/55c0667d7b264_lottery.jpg?imageView2/2/w/200/q/80'
        };
        return shareData
    },

    mobileInputHandle: function(e){
        var mobile = e.target.value;
        this.setState({
            mobile: +mobile
        })
    },
    remindHandle: function(){
        var mobile = this.state.mobile;
        console.log(A('member').islogin());

        liteFlux.action("activity-november").remind(mobile);
        return false;
    },
    loginHandle: function(){
        if(!SP.loginboxshow){
            SP.loginboxshow = true;
            SP.loadLogin({
                success: function() {
                    window.location.reload();
                }
            })

        }

    },
    ActivityBannerNode: function(){

        var bannerImg = this.state.banner;
        var content = <div className='remind-content'><p>我们将会在活动当天提前30分钟以短信的形式通知您</p><p><Input id='mobile_val' value={this.state.mobile} onChange={this.mobileInputHandle} /></p></div>;

        var confirm_content = '';
        if(A('member').islogin()){
            confirm_content = (
                <Confirmable
                    className='remind-btn'
                    title='设置短信提醒'
                    content={content}
                    confirm={this.remindHandle}
                    >
                </Confirmable>
            )
        }else{
            confirm_content = (
                <Tappable className='remind-btn' onTap={this.loginHandle}></Tappable>
            )
        }

        var _this_node = (
                <div style={{position:'relative'}}>
                    <Img alt="" src={bannerImg.url} width='100%'/>
                    {confirm_content}
                </div>
            );
        return _this_node;
    },

    couponHandle: function(coupon_id,title,content){
        var text_content = <span style={{display:'inline-block',width:'100%',textAlign:'center',paddingTop:'20px'}}>您可以在<span style={{color:'#fa6400'}}>个人中心-我的优惠券</span>中查看</span>
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
                    <div style={{position:'relative'}}>
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

    AdImgNode: function(){

        var _this = this;

        var adImgArr = this.state.adImgUrl;

        var _this_node = adImgArr.map(function(item,key){
            var endTips = function(){
                alert('本场活动已结束!');
            };
            if(timeManage.before('2015-11-13 16:00:00')){
                return (
                    <div key={key}>
                        <Link href={_this.state.november_second_activity}><Img alt="" src={item.url} w={640} width='100%'/></Link>
                    </div>
                )
            }else{
                return (
                    <div key={key}>
                        <a onClick={endTips} href="javascript:;"><Img alt="" src={item.url} w={640} width='100%'/></a>
                    </div>
                )
            }
        });
        return _this_node;
    },

    FooterImgNode: function(){
        var footerImg = this.state.footerImg;
        var _this_node = (
                <div>
                    {
                        footerImg.map(function(item,key){
                            return (
                                <div className='footer-img' key={key}>
                                    <Img alt="" src={item.url} w={640} width='100%'/>
                                </div>
                            )
                        })
                    }
                    <div style={{clear: 'both'}}></div>
                </div>
            );
        return _this_node;
    },

    onShareWeibo: function(e){
        if(e){
            e.preventDefault();
            e.stopPropagation();
        }
        A('share').onShareWeibo(this.shareWeiboData())
       /* liteFlux.action("activity-november").setAttendance(2,this.shareWeiboData());*/
    },

    is_weixin: function(){
        var ua = navigator.userAgent.toLowerCase();
        return (/MicroMessenger/i).test(ua);

    },
    onShareWeixin: function(e){
        if(e){
            e.preventDefault();
            e.stopPropagation();
        }
        var is_weixin = this.is_weixin();
        if(is_weixin){
            SP.message({msg: "请点击右上角分享给朋友们"});
        }
        else{
            A('share').onShareQrcode(this.props.shareUrl);
        }
    },

    shareBtn: function(){
        return (
            <div className="u-flex-box lottery-share-modal u-text-center u-pt-20">
                <div className="u-flex-item-1">
                    <Tappable className="icon icon-weibo" onTap={this.onShareWeibo}>微博</Tappable>
                </div>
                <div className="u-flex-item-1">
                    <Tappable className="icon icon-weixin" onTap={this.onShareWeixin}>微信</Tappable>
                </div>
            </div>
        )
    },

    warnHandle: function(){
        if(timeManage.before('2015-11-10 00:00:00')){
            var title = <span>想玩?电脑上<span style={{color:'#fa6400'}}>sipin.com</span>，大奖带回家！</span>
            SP.alert({
                title: title,
                confirmText: '知道啦',
                showCloseIcon: false,
                bsStyle: 'red'
            });
        }else{
            alert('本场活动已结束');
        }
    },
    render: function() {

        var title = '活动预告';
        /*slider 要传入的数据*/
        var slide_arr = this.state.slideImg;

        var BottomBannerDom = '';
        if(timeManage.before('2015-08-01 00:00:00')){
            BottomBannerDom = (<BottomBanner />);
        }

        var share = this.shareBtn();

      /*  <div>
            <Alertable className="share-btn" showConfirmBtn={false} contentElement={share} showCloseIcon={false} maskClose={true}>分享</Alertable>
        </div>*/
        return (
            <Page className="website-index">
                <Navbar leftNavbar={<BackButton />}  title = {title}></Navbar>
                {BottomBannerDom}
                <PageContent className="bg-white" id="index-page">

                    {this.ActivityBannerNode()}
                    {this.CouponImgNode()}

                    <div className='activity-november'>
                        <div className='activity-shape-icon'><img src="../images/activity/2015-11/shape-icon.png" alt="" width='30'/></div>
                        <div className='activity-title'>
                            <h3>来斯品<span className='grey'>玩找茬</span>，玩出一个“家”</h3>
                            <h3>11.3~11.10</h3>
                        </div>
                    </div>

                    <Tappable onTap={this.warnHandle}>
                        <Slide banner data={slide_arr} nav-center nav-gold w={640}></Slide>
                    </Tappable>

                    <div className='activity-november'>
                        <div className='activity-shape-icon'><img src="../images/activity/2015-11/red-icon.png" alt="" width='30'/></div>
                        <div className='activity-title'>
                            <h3><span className='red'>脱光利润</span>，不玩虚的</h3>
                            <h3>11.6~11.13</h3>
                        </div>
                    </div>

                    {this.AdImgNode()}

                    <div className='activity-november'>
                        <div className='activity-shape-icon'><img src="../images/activity/2015-11/green-icon.png" alt="" width='30'/></div>
                        <div className='activity-title'>
                            <h3>终极返场，<span className='green'>大奖抽不完</span></h3>
                            <h3>11.25~11.28</h3>
                        </div>
                    </div>

                    {this.FooterImgNode()}

                    <div>
                        <div className="index-footer">
                            <span>
                                Copyright &copy; {Year} 斯品sipin.com 版权所有</span>
                        </div>
                    </div>

                </PageContent>
                <LiteCart/>
            </Page>
        );
    }
});

module.exports = PageView;
