module.exports = {
    // 用户登录
    memberLogin: function() {
        var MemberLogin = require('pages/member/login/login');
        return (
            <View className="view-login">
                <MemberLogin></MemberLogin>
            </View>
        );
    },
    // 用户注册
    memberRegister: function(code) {
        var MemberRegister = require('pages/member/register/register');
        if(typeof code === "string"){
            return (
                <View className="view-register">
                    <MemberRegister code={ code }></MemberRegister>
                </View>
            );
        }else{
            return (
                <View className="view-register">
                    <MemberRegister></MemberRegister>
                </View>
            );
        }

    },
    // 用户注册-完成注册
    memberRegisterComplete: function() {
        var MemberRegisterComplete = require('pages/member/register/register-complete');
        return (
            <View className="view-register">
                <MemberRegisterComplete></MemberRegisterComplete>
            </View>
        );
    },
    // 用户中心首页
    memberIndex: function(text) {
        var MemberIndex = require('pages/member/index/index');
        return (
            <View>
                <MemberIndex></MemberIndex>
            </View>
        );
    },
    // 用户资料首页
    profileIndex: function(){
        var ProfileIndex = require('pages/member/profile/profile');
        return (
            <View>
                <ProfileIndex></ProfileIndex>
            </View>
        );
    },
    // 用户收藏首页
    favoriteIndex: function(){
        var FavoriteIndex = require('pages/member/favorite/favorite');
        return (
            <View>
                <FavoriteIndex></FavoriteIndex>
            </View>
        );
    },
    // 用户优惠劵首页
    couponIndex: function(){
        var CouponIndex = require('pages/member/coupon/coupon');
        return (
            <View>
                <CouponIndex type="member"></CouponIndex>
            </View>
        );
    },
    // 会员权益卡首页
    serviceCardIndex: function(){
        var Page = require('pages/member/service-card/index');
        return (
            <View>
                <Page type="member"></Page>
            </View>
        );
    },
    // 用户退换货首页
    aftersalesIndex: function(){
        var AftersalesIndex = require('pages/member/aftersales/aftersales');
        return (
            <View>
                <AftersalesIndex></AftersalesIndex>
            </View>
        );
    },
    // 用户订单首页
    orderIndex: function(status){
        var OrderIndex = require('pages/member/order/list/list');
        return (
            <View>
                <OrderIndex status={status}></OrderIndex>
            </View>
        );
    },
    // 用户订单-详情
    orderDetail: function(id){
        var OrderDetail = require('pages/member/order/detail/detail');
        return (
            <View>
                <OrderDetail id={id}></OrderDetail>
            </View>
        );
    },
    // 修改用户名
    profileUsername: function(){
        var ProfileUsername = require('pages/member/profile/username/username');
        return (
            <View>
                <ProfileUsername></ProfileUsername>
            </View>
        );
    },
    // 修改手机号
    profileMobile: function(){
        var ProfileMobile = require('pages/member/profile/mobile/mobile');
        return (
            <View>
                <ProfileMobile></ProfileMobile>
            </View>
        );
    },
    // 修改手机号-填写新手机号
    profileBindMobile: function(type){
        var ProfileBindMobile = require('pages/member/profile/mobile/mobile-bind');
        return (
            <View>
                <ProfileBindMobile type={type}></ProfileBindMobile>
            </View>
        );
    },
    // 修改真实姓名
    profileRealname: function(){
        var ProfileRealname = require('pages/member/profile/realname/realname');
        return (
            <View>
                <ProfileRealname></ProfileRealname>
            </View>
        );
    },
    // 修改密码-修改
    profilePassword: function(type){
        var ProfilePasswordChange = require('pages/member/profile/password/password');
        return (
            <View>
                <ProfilePasswordChange type={type}></ProfilePasswordChange>
            </View>
        );
    },
    // 地址管理
    addressIndex: function(){
        var Address = require('pages/member/address/address');
        return (
            <View>
                <Address type="profile"></Address>
            </View>
        );
    },
    // 地址修改
    addressEdit: function(){
        var AddressEidt = require('pages/member/address/new-address');
        return (
            <View>
                <AddressEidt type="profile" edit></AddressEidt>
            </View>
        );
    },
    // new地址
    addressCreate: function(){
        var AddressEidt = require('pages/member/address/new-address');
        return (
            <View>
                <AddressEidt type="profile"></AddressEidt>
            </View>
        );
    },
    // 忘记密码
    forgotPassword: function(){
        var ForgotPassword = require('pages/member/forgot-password/forgot-password');
        return (
            <View>
                <ForgotPassword></ForgotPassword>
            </View>
        );
    },
    // 我的推荐
    referral: function(){
        var Referral = require('pages/member/referral/referral');
        return (
            <View>
                <Referral></Referral>
            </View>
        );
    },
    // 我的积分
    pointIndex: function(){
        var Point = require('pages/member/point/point');
        return (
            <View>
                <Point></Point>
            </View>
        );
    },
    // 积分兑换
    exchangeIndex: function(){
        var Exchange = require('pages/member/point/exchange');
        return (
            <View>
                <Exchange></Exchange>
            </View>
        );
    },
    // 注册分享
    shareInvite: function(code){
        //var moment = require('moment');
        var ShareDefaultInvite = require('pages/member/invite/share');
        //var ShareInvite = require('react-proxy!pages/member/invite/activity-share');
        //var startDiff = moment( '2015-08-01 00:00:00' ).diff( moment(), 'seconds');
        // console.log(startDiff);
        // if(startDiff > 0){
        //     return (
        //         <View>
        //             <ShareInvite code={code}></ShareInvite>
        //         </View>
        //     );
        // }else{
        //     return (
        //         <View>
        //             <ShareDefaultInvite code={code}></ShareDefaultInvite>
        //         </View>
        //     );
        // }
        return (
            <View>
                <ShareDefaultInvite code={code}></ShareDefaultInvite>
            </View>
        );

    },
    // 注册后分享页
    registerInvite: function(){
        var RegisterInvite = require('pages/member/invite/register');
        return (
            <View>
                <RegisterInvite></RegisterInvite>
            </View>
        );
    }
};
