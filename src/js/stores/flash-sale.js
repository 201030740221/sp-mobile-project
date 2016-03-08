var flashSale = {};

flashSale.constants = {
    CODE_FLASHSALE_READY:'101',
    CODE_FLASHSALE_STARTED: '102',
    CODE_FLASHSALE_ENDED: '103',
    CODE_FLASHSALE_FROZEN: '104',
    CODE_FLASHSALE_AVAILABLE: '105',
    CODE_FLASHSALE_RESERVED: '106',
    CODE_FLASHSALE_ALREADY_PARTICIPATED: '107',
    CODE_FLASHSALE_STILL_HAVE_A_CHANCE: '108',

    CODE_FLASHSALE_LOOT_RESERVED: '201',
    CODE_FLASHSALE_LOOT_FAILED: '202',

    CODE_FLASHSALE_ACTION_UNFREEZE: '301'
};

flashSale.constantNames = {
    '1': '未登录或flashSaleId有误',
    '101': '准备开始',
    '102': '进行中',
    '103': '已结束',
    '104': '(冻结)已抢完,还有机会',
    '105': '机会来了',
    '106': '已抢到,快付款',
    '107': '已抢过',
    '108': '已抢完,还有机会',
    '201': '抢购操作反馈-成功',
    '202': '抢购操作反馈-失败',
    '301': '特殊操作-解冻'
};

var moment = require('moment');
var socket = require('modules/lib/websocket/websocket');


var store = liteFlux.store("flashsale",{
    data: {
        enterFlashsale: false,
        channel: null,
        nowTime: moment().format( 'YYYY-MM-DD HH:mm:ss' ),
        diffTime: 0,
        attribute_key: {},
        isFlash: true,
        flashStatus: 0,
        mobile_bound: false,
        countdownText: "加载中...",
        websocket_ready: false, // 是否准备好系统
        websocket_close: false, // 是否关闭
        websocket_code: 0,
        isworking: false
    },
    actions:{
        initChannel: function(){

            // 增加环境判断
            this.setStore({
                channel: new socket({
                    url: sipinConfig.websocket
                })
            });

            var store = this.getStore();
            var channel = store.channel;

            channel.on('open', function () {
                S('flashsale',{
                    websocket_ready: true
                });
                //console.log('opening socket...');
            });

            channel.on('close', function () {

                if( A("member").islogin() && S("flashsale").enterFlashsale == true ){
                    channel.reconnect();
                }

                S('flashsale',{
                    websocket_close: true
                });
                //console.log('closed socket...');
            });
            channel.on('message', function (resp, e) {

                //console.log('message: ', resp);

                var code = resp.code;

                if (typeof code !== "undefined"){
                    S('flashsale',{
                        websocket_code: parseInt(code)
                    });
                };


                if ( resp && resp.data && resp.data.time) {
                    var serverTime = moment.unix( resp.data.time ).format( 'YYYY-MM-DD HH:mm:ss' );
                    S("flashsale",{
                        nowTime: serverTime
                    });
                }



                if( resp.code ){
                    switch ( parseInt(code) ) {
                        case 1:
                            // 清空登录信息
                            A("member").logout();
                            break;
                        case 201:
                            SP.alert({
                                show: false
                            });
                    
                            var flashsaleStore = S('flashsale');

                            var data = {
                                // 'type':'flash_sale',
                                'flash_sale_id': flashsaleStore.flashsale.id,
                                'region': S('region').district,
                                // 'is_multiple': 0,
                                // 'quantity': 1,
                                // 'item': flashsaleStore.goodData.baseData.goods_sku_id,
                                // 'sku_sn': flashsaleStore.goodData.baseData.sku_sn
                            };
                            liteFlux.action("checkout").checkout(data, 'flashsale');
                            break;
                        case 202:
                            SP.alert({
                                show: false
                            });
                            SP.message({
                                msg: "秒杀失败！"
                            });
                            break;
                        case 203:
                            document.getElementById('captcha').src = apihost + "/flash-sale/captcha?user_key=" + S("member").user_key + "&flash_sale_id="+ S('flashsale').flashsale.id + "&t=" + Math.random();
                            document.getElementById('flashsale-captcha-code').value="";
                            SP.message({
                                msg: "验证码错误！"
                            });
                            break;
                        default:
                            break;
                    }
                    //console.info(code, ":",flashSale.constantNames[code]);
                }


            });

            channel.on('ping', function (data, e) {
                channel.send({type: 'pong'});
            });
        },
        closeChannel: function(){

            var store = this.getStore();
            var channel = store.channel;

            if(channel)
                channel.close();

            this.setStore({
                enterFlashsale: false,
                channel: null
            });
        },
        getDelivery: function(){
            var _this = this;
            var region = S('region');
            var sku_id = this.getStore().sku_id;
            var data = {
                'goods_sku_id': sku_id,
                'region_id': region.district
            };
            // 计算运费
            // webapi.goods.getDelivery(data).then(function(res){ // 请求运费
            //     if(res.code === 0){
            //         _this.setStore({
            //             delivery_price: res.data,
            //             delivery_region_id: region.district
            //         });
            //     }
            // });
            //运费直接设置为0
            _this.setStore({
                delivery_price: 0,
                delivery_region_id: region.district
            });
        },
        getGoodDetails: function(g_id) {

            var data = {'sid':g_id};
            var _this = this;
            SP.loading(true);
            webapi.activity.flashSaleDetail(data).then(function (result) {

                if (result && result.code === 0) {

                    liteFlux.store("flashsale").reset();

                    var good_detail = result.data;
                    // var data = {
                    //     'goods_sku_id': good_detail.baseData.goods_sku_id ,
                    //     'region_id': region_id
                    // };

                    // 保存当前 SKU 属性
                    var attribute_state = {};
                    var attribute_key = good_detail.baseData.attribute_key;
                    var attribute = attribute_key.split(',');
                    attribute.map(function(item){
                        var attr = item.split('-');
                        attribute_state[attr[0]] = parseInt(attr[1]);
                    });
                    var dataList = {
                        enterFlashsale: true,
                        channel: _this.getStore().channel,
                        nowTime: moment().format( 'YYYY-MM-DD HH:mm:ss' ),
                        'sku_id': good_detail.baseData.goods_sku_id,
                        'goodData':good_detail ,
                        // 'delivery_price': res.data ,
                        // 'delivery_region_id': region_id ,
                        'attribute_key': attribute_state,
                        flashsale: good_detail.flashsale,
                        mobile_bound: good_detail.flashsale.mobile_bound
                    };
                    //dataList.flashsale.begin_at = "2015-07-19 12:07:00";
                    A("flashsale").closeChannel();
                    _this.reset();
                    _this.setStore(dataList);
                    A("flashsale").initChannel();

                    // channel.send({
                    //     "type":"connect",
                    //     "userKey": S("member").user_key,
                    //     "flashSaleId": S("flashsale").flashsale.id
                    // })
                    var store = _this.getStore();
                    var channel = store.channel;

                    channel.connect(function () {
                        channel.send({
                            "type":"connect",
                            "userKey": S("member").user_key || '',
                            "flashSaleId": S("flashsale").flashsale.id || ''
                        })
                    });
                    // webapi.goods.getDelivery(data).then(function(res){ // 请求运费
                    //
                    //
                    //
                    // });
                }else{
                    SP.redirect('/404',true);
                }
                SP.loading(false);
            });
        },
        addPhoneToClock: function(mobile,callback){

            var self = this;

            if(/^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$/.test(mobile)){

                var data = {
                    mobile: mobile,
                    flash_sale_id: S("flashsale").flashsale.id
                };

                webapi.activity.noticeRegister(data).then(function(res){
                    if(res && res.code==0){
                        self.setStore({
                            mobile_bound: true
                        });

                        if(callback) callback({
                            code: 0,
                            msg: "设置手机提醒成功"
                        });

                    }else{

                        if(callback) callback({
                            code: 1,
                            msg: "设置手机提醒失败"
                        });
                    }
                });

                return true;

            }else{
                if(callback) callback({
                    code: 1,
                    msg: "请输入正确的手机号码"
                });
                return false;
            }


        }
    }
});

// channel.connect(function () {
//     console.log(S("member").user_key);
//     channel.send({
//         "type":"connect",
//         "userKey": S("member").user_key,
//         "flashSaleId": "5"
//     })
// });

module.exports = store;
