/**
 * 程序全局变量，方便调用
 */
window.React = require('react');
window.liteFlux = require('lite-flux');
// liteFlux 简单方法
window.A = function(){
    if(arguments.length===1){
        return liteFlux.store(arguments[0]).getAction();
    }else{
        return liteFlux.store(arguments[0]).addAction(arguments[1],arguments[2]);
    }
};
window.S = function(){
    if(arguments.length===1){
        return liteFlux.store(arguments[0]).getStore();
    }else{
        if(arguments[1]===null){
            return liteFlux.store(arguments[0]).destroy();
        }else if(arguments[1]===true){
            return liteFlux.store(arguments[0]).reset();
        }else{
            return liteFlux.store(arguments[0]).setStore(arguments[1]);
        }
    }
};

// 全局 utils
window.SP = require('SP');

// 引用基础组件
var components = require('components/index');
for (var c in components){
    window[c] = components[c];
}

// 引用项目组件
var modules = require('modules/index');
for (var m in modules){
    window[m] = modules[m];
}

// 用于表单双向绑定
window.LinkedStateMixin = require('react/lib/LinkedStateMixin');

window.MemberAuthMixin = ModulesMixins.memberAuthMixin;
window.MemberCheckLoginMixin = ModulesMixins.memberCheckLoginMixin;

// 页面历史记录管理
window.pageHistory = require('utils/history');

// 存储当前页面
pageHistory.add({
    url: window.location.hash.replace('#!','')
});

// stores
window.appStores = require('stores/index');

/**
 * 从本地存储中取缓存数据
 * 应该在此处完成本地存储与sotre之间的初始化数据存取
 */
liteFlux.action("member").getMemberFromLocalStore();

// api 域名
window.apihost = '';

// 根据配置文件切换 api 域名
// 线上环境
if(sipinConfig.env === "production"){

    // 载入美洽
    var meiqia = require('vendor/meiqia');
    meiqia.loadjs();
    window.getMeChatPartnerUserID = function(){
        return {
            userId: S("member").user_key || ''
        };
    };

    apihost = sipinConfig.apiHost;
    // 配置百度统计
    window._hmt= window._hmt || [];
    (function(){
        var hm=document.createElement("script");
        hm.src="//hm.baidu.com/hm.js?fb7a7bd1ca70909e34608685bac47e9f";
        var s=document.getElementsByTagName("script")[0];s.parentNode.insertBefore(hm,s);
    })();

    // 对当前 url 加入统计
    _hmt.push(['_trackPageview', window.location.href ]);

    // 配置99click
    var click99 = require('vendor/click99');
    window._ozuid = S("member").analytics_user_key;
    click99.loadjs(function(){
        // 创建统计事件代理
        liteFlux.event.on("click99",function(evt,val){
            //console.log(evt,val);
            switch (evt) {
                // 页面统计
                case "view":
                    __ozfac2( null, window.location.href );
                    break;
                // 搜索统计
                case "search":
                    __ozfac2( val , "#!/search");
                    break;
                // 下单统计
                case "checkout":
                    __ozfac2( val , "#!/payment");
                    break;
                // 商品详情统计
                case "item":
                    __ozfac2( val , "#!/item");
                    break;
                // 订单完成统计
                case "order-complete":
                    __ozfac2( val , "#!/payment");
                    break;
                // 注册统计
                case "register":
                    __ozfac2( val , "#regok");
                    break;
                // 点击统计
                case "click":
                    __ozflash( val );
                    break;
                default:
                    break;

            }
        });
        // 对当前 url 加入统计
        liteFlux.event.emit('click99',"view");
    });

    // 同时在 hashchange 里进行统计
    window.onhashchange = function(){
        _hmt.push(['_trackPageview', window.location.href ]);
        liteFlux.event.emit('click99',"view");
    };

}else if(sipinConfig.env === "test"){ // 测试环境
    apihost = sipinConfig.apiTestHost;
}else { // 开发环境
    try{
        var developConfig = require('developConfig');
        if(developConfig.isProxy){
            apihost = "http://" + window.location.host + '/api';
        }else{
            apihost = developConfig.apiDevHost;
        }
    }catch(e){
        if(sipinConfig.isProxy){
            apihost = "http://" + window.location.host + '/api';
        }else{
            apihost = sipinConfig.apiDevHost;
        }
    }

}

// apihost = 'http://www.sipin.latest.dev.e.sipin.one/api';

// 引用 webapi
window.webapi = require('sipin-web-api')({
    host: apihost,
    crossDomain: true,
    headers: {
        'X-XSRF-TOKEN': function (options) {
            var token = null
            if (options.method.toLowerCase() != 'get') {
                token =  SP.cookie.get('XSRF-TOKEN');
            }

            return token;
        }
    }
});



var RouterMixin = require('react-mini-router').RouterMixin;
// routes
var cartRoutes = require('pages/main/routes/cart-routes');
var goodRoutes = require('pages/main/routes/goods-routes');
var memberRoutes = require('pages/main/routes/member-routes');
var paymentRoutes = require('pages/main/routes/payment-routes');
var lotteryRoutes = require('pages/main/routes/lottery-routes');
var activityRoutes = require('pages/main/routes/activity-routes');
var shareRoutes = require('pages/main/routes/share-routes');
var presalesRoutes = require('pages/main/routes/presales-routes');

// 微信分享
A('share').initWeixinShare();

/**
 * 程序路由
 */
var App = React.createClass({

    mixins: [RouterMixin,cartRoutes,goodRoutes,memberRoutes,paymentRoutes,lotteryRoutes,activityRoutes,shareRoutes,presalesRoutes],

    routes: {
        '/': 'home',
        '/category/view/:type':'searchIndex', // type = 'list' | 'search'
        '/cart': 'cart',
        '/checkout': 'checkout',
        '/checkout/address': 'checkoutAddress',
        '/checkout/address/create': 'checkoutNewAddress',
        '/checkout/invoice': 'checkoutInvoice',                      // 发票
        '/checkout/coupon': 'checkoutCoupon',                        // 我的优惠劵
        '/checkout/service-card': 'checkoutServiceCard',             // 会员权益卡
        '/exchange/checkout': 'exchangeCheckout',                    // 积分兑换结算
        '/exchange/address': 'exchangeAddress',
        '/exchange/address/create': 'exchangeNewAddress',
        '/payment/:id': 'payment',                                   // 支付
        '/payment/complete/:id/:no': 'paymentComplete',              // 支付完成页面
        '/member': 'memberIndex',                                    // 用户中心首页
        '/member/point': 'pointIndex',                               // 我的积分
        '/member/point/exchange': 'exchangeIndex',                   // 积分兑换
        '/member/profile': 'profileIndex',                           // 我的信息
        '/member/favorite': 'favoriteIndex',                         // 我的收藏
        '/member/coupon': 'couponIndex',                             // 我的优惠劵
        '/member/service-card': 'serviceCardIndex',                  // 会员权益卡
        '/member/address': 'addressIndex',                           // 地址管理
        '/member/address/create': 'addressCreate',                   // 新地址
        '/member/address/edit': 'addressEdit',                       // 修改地址
        '/member/aftersales': 'aftersalesIndex',                     // 退换货
        // all(全部) || pending(待付款) || notyetshiped(待发货) || shiping(待收货) || evaluate(待评价)
        '/member/order/:status': 'orderIndex',                       // 订单页面
        '/member/order/detail/:id': 'orderDetail',                   // 订单详情
        '/member/profile/username': 'profileUsername',               // 修改用户名
        '/member/profile/mobile': 'profileMobile',                   // 修改手机号
        '/member/profile/mobile/:type': 'profileBindMobile',         // 修改手机号-填写新手机号
        '/member/profile/realname': 'profileRealname',               // 修改真实姓名
        '/member/profile/password/:type': 'profilePassword',         // 修改密码
        '/member/login': 'memberLogin',                              // 用户登录
        '/member/register': 'memberRegister',                        // 用户注册
        '/member/register/referral/:code': 'memberRegister',         // 用户注册带邀请码
        '/member/register/complete': 'memberRegisterComplete',       // 用户注册-完成注册
        '/member/forgot/complete': 'forgotPassword',                 // 忘记密码-完成
        '/member/referral': 'referral',                              // 我的推荐
        '/item/:id': 'goodDetail',
        '/item/:id/comment': 'commentIndex',
        '/flashsale/:id': 'flashsale',
        '/flashsale/detail/:id': 'flashsaleMoreDetail',
        '/more-item/:id': 'goodMoreDetail',
        '/category/:id': 'goodsList',                                // 商品列表
        '/search/:keyword': 'goodsSearch',                           // 商品搜索列表
        '/lottery/:id': 'lottery',                                   // 抽奖
        '/activity/july': 'activityJuly',                            // 争分夺秒活动主页
        '/activity/november': 'activityNovember',                    // 11月活动主页
        '/activity/novemberTakeOff': 'activityNovemberTakeOff',
        '/activity/november4': 'activityNovember4',                  // 11月活动4, 返场活动
        '/share/weixin/:url': 'shareWeixin',                         // 二维码
        '/share/weixin': 'shareWeixin',                              // 二维码
        '/member/invite/:code': 'shareInvite',                       // 注册分享
        '/member/register/invite': 'registerInvite',                 // 注册后分享页
        '/presales/home': 'presalesHome',                            // 预售首页
        '/presales/detail/:id': 'presalesDetail',                    // 预售详情
        '/presales/guide': 'presalesGuide'                           // 预售攻略
    },

    componentDidMount: function(){
        var self = this;
        SP.event.on("router.setpath",function(path) {
            self.setState({ path: path });
        });
    },

    componentWillMount: function(){
        SP.event.off("router.setpath");
    },

    render: function() {
        return this.renderCurrentRoute();
    },

    home: function() {
        var Website = require('pages/website/website');
        return (
            <View>
                <Website></Website>
            </View>
        );
    },


    notFound: function(path) {
        var NotFound = require('pages/error/404/404');
        return (
            <View>
                <NotFound path={path}></NotFound>
            </View>
        );
    }

});

React.render( <Container><App /></Container>, document.getElementById('app-container'));
