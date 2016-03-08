/**
 * fix footer nav
 */

var moment = require('moment');
var CountDown = require('components/lib/count-down');

var CountDownContent = React.createClass({
    render: function(){
        var timeTitle = '距离开始时间：';
        if(this.props.isworking){
            timeTitle = '距离结束时间：';
        }
        if(this.props.days === 0 && this.props.hours === 0 && this.props.minutes === 0 && this.props.seconds === 0){
            return (
                <div className="flashsale-countdown">{timeTitle}<em>加载中...</em> </div>
            );
        } else{
            return (
                <div className="flashsale-countdown">{timeTitle}<em>{this.props.days + "天 " + this.props.hours + ":" + this.props.minutes + ":" + this.props.seconds}</em> </div>
            );
        }

    }
});

var count = 1;
var GoodFooterNav = React.createClass({
    mixins:[liteFlux.mixins.storeMixin('flashsale')],
    loginIn: function(){
        SP.loadLogin({
            success: function(){
                window.location.reload();
            }
        });
    },
    payGoods: function(){
        var data = {
            // 'type':'flash_sale',
            'flash_sale_id': S('flashsale').flashsale.id,
            'region': S('region').district
        };

        liteFlux.action("checkout").checkout(data, 'flashsale');
    },
    // 马上秒杀
    buyRightNow: function(captcha_code){
        var self = this;


        S("flashsale").channel.send({
            "type":"loot",
            "captcha": captcha_code,
            "userKey": S("member").user_key || '',
            "flashSaleId": S("flashsale").flashsale.id || ''
        });

        return true;

    },
    setBeginTime: function(){
        S("flashsale",{
            nowTime: S("flashsale").flashsale.begin_at
        });
    },
    setEndTime: function(){
        S("flashsale",{
            nowTime: S("flashsale").flashsale.end_at
        });
    },
    // 准备开始
    isReady: function(){
        var now = this.state.flashsale.nowTime,
            nextmonday = moment( S("flashsale").flashsale.begin_at ),
            diff = nextmonday.diff(now, 'seconds');
        //console.log(1,diff);
        // 准备开始或者还有机会
        if( (S("flashsale").websocket_code==101 || diff>0) && !this.isWorking() ){
            return true;
        }else{
            return false;
        }
    },
    // 正在进行中
    isWorking: function(){
        var now = S('flashsale').nowTime,
            nextmonday = moment( S("flashsale").flashsale.begin_at ),
            diff = nextmonday.diff(now, 'seconds');
        //console.log(2,diff);
        if ( (S("flashsale").websocket_code==102 || S("flashsale").websocket_code==105  || S("flashsale").websocket_code==301 || diff<=0) && !this.isOver() && S("flashsale").websocket_code!=104 && S("flashsale").websocket_code!=108 ){
            if (S("flashsale").websocket_code==201 || S("flashsale").websocket_code==202){
                return false;
            }
            return true;
        }else{
            return false;
        }
    },
    // 还有机会
    isHasChange: function(){
        if ( S("flashsale").websocket_code==104 || S("flashsale").websocket_code==108 || S("flashsale").websocket_code==202 ){
            return true;
        }else{
            return false;
        }
    },
    // 是否已结束
    isOver: function(){
        var now = S('flashsale').nowTime,
            nextmonday = moment( S("flashsale").flashsale.end_at ),
            diff = nextmonday.diff(now, 'seconds');

        // 正在进行或者机会来了
        if ( ( S("flashsale").websocket_code==103 || S("flashsale").websocket_code==107 || S("flashsale").websocket_code==201 || S("flashsale").websocket_code==106 ||  !S('flashsale').flashsale.enable || diff < 0 ) && !this.isReady() ){
            if ( S("flashsale").websocket_code==104 || S("flashsale").websocket_code==108 ){
                return false;
            }else{
                return true;
            }
        }else{
            return false;
        }
    },
    getCaptcha: function(){
        document.getElementById('captcha').src = apihost+"/flash-sale/captcha?user_key="+ S("member").user_key +"&flash_sale_id="+S('flashsale').flashsale.id + "&" + Math.random();
    },
    showCaptcha: function(){

        var self = this;

        // 是否登录
        if(A("member").islogin()){

            SP.alert({
                content: this.renderVerifyCode(),
                title: "请输入验证码",
                confirmText: "立即秒杀",
                confirm: function(){
                    var captcha = document.getElementById("flashsale-captcha-code");
                    if(captcha.value!==''){
                        document.getElementById('flashsale-captcha-code-error').innerHTML = "";
                        self.buyRightNow(captcha.value);
                        // 203状态重刷验证码
                    }else{
                        document.getElementById('flashsale-captcha-code-error').innerHTML = "验证码错误，请重试输入";
                    }
                    return false;
                }
            });

        }else{
            SP.loadLogin({
                success: function(){
                    window.location.reload();
                }
            });
            return true;
        }
    },
    // 渲染验证码界面
    renderVerifyCode: function(){
        return (
            <Panel className="flash-sale-captcha form">
                <Grid className="register-picture-code" cols={24}>
                    <Col span={15}>
                        <div className="register-input">
                            <Input id="flashsale-captcha-code" type="text" placeholder="图形验证码" />
                        </div>
                    </Col>
                    <Col span={9} className="u-text-right">
                        <div className="register-picture-code-btn">
                            <img onClick={this.getCaptcha} src={apihost+"/flash-sale/captcha?user_key="+ S("member").user_key +"&flash_sale_id="+S('flashsale').flashsale.id} alt="" className="captchaCode" id="captcha" />
                        </div>
                    </Col>
                </Grid>

                <div id="flashsale-captcha-code-error" className="form-error-info u-mt-10"></div>
            </Panel>
        );
    },
    // 准备期间 <div className="flashsale-countdown">剩余时间：<em>{this.state.flashsale.countdownText}</em> </div>
    renderReady: function(){
        return (
            <div>
                <CountDown callback={this.setBeginTime} data={{ startTime: this.state.flashsale.nowTime, endTime: S("flashsale").flashsale.begin_at }} component={CountDownContent} />
                <Button danger disabled={this.isReady()} className="flashsale-submit">即将开始</Button>
            </div>
        );
    },
    // 进行中，未登录
    renderWork: function(){
        return (
            <div>
                <CountDown callback={this.setEndTime} isworking={true} data={{ startTime: S("flashsale").nowTime, endTime: S("flashsale").flashsale.end_at }} component={CountDownContent} />
                <Button danger disabled={this.isOver()} onTap={this.loginIn} className="flashsale-submit">立即秒杀</Button>
            </div>
        );
    },
    // 进行中，还有机会
    renderHasChange: function(){
        return (
            <div>
                <CountDown callback={this.setEndTime} isworking={true} data={{ startTime: S("flashsale").nowTime, endTime: S("flashsale").flashsale.end_at }} component={CountDownContent} />
                <Button danger disabled={true} className="flashsale-submit">还有机会</Button>
            </div>
        );
    },
    // 进行中
    renderWorking: function(){
        return (
            <div>
                <CountDown callback={this.setEndTime} isworking={true} data={{ startTime: S("flashsale").nowTime, endTime: S("flashsale").flashsale.end_at }} component={CountDownContent} />
                <Button danger disabled={this.isOver()} className="flashsale-submit" name="seckill" onTap={this.showCaptcha}>立即秒杀</Button>
            </div>
        );
    },
    // 已结束
    renderOver: function(){
        if(S("flashsale").websocket_code==106){
            return (
                <div>
                    <div className="flashsale-countdown"><em className='u-f12'>您已秒杀成功，请在秒杀完15分钟内付款</em> </div>
                    <Button danger className="flashsale-submit" onTap={this.payGoods}>立即付款</Button>
                </div>
            );
        }else{
            return (
                <div>
                    <div className="flashsale-countdown">距离结束时间：<em>秒杀已结束</em> </div>
                    <Button danger disabled={true} className="flashsale-submit">已结束</Button>
                </div>
            );
        }

    },
    // 渲染视图
    render: function() {

        // console.log( this.isReady() , this.isWorking() ,  this.isHasChange() , this.isOver() );

        if( this.isReady() && !this.isWorking() &&  !this.isHasChange() && !this.isOver() ){ // 准备开始
            return this.renderReady();
        }else if ( !this.isReady() && !this.isWorking() &&  this.isHasChange() && !this.isOver() ){ // 立即秒杀
            return this.renderHasChange();
        }else if ( !this.isReady() && this.isWorking() &&  !this.isHasChange() && !this.isOver() ){ // 已结束
            if (A("member").islogin()){ // 已登录
                return this.renderWorking();
            }else{ // 未登录
                return this.renderWork();
            }
        }else if ( !this.isReady() && !this.isWorking() &&  !this.isHasChange() && this.isOver() ){ // 还有机会
            return this.renderOver();
        }else {
            // 如果状态错误，直接跳 404
            return (
                <div>
                    <div className="flashsale-countdown">请刷新当前页面参与秒杀</div>
                </div>
            );
        }

    }
});

module.exports = GoodFooterNav;
