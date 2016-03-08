var constant = {
    furniture: 0, // 家具
    textile: 1 // 家纺
}

var store = liteFlux.store("detail",{
    data: {
        attribute_key: {},
        quantity: 1
    },
    actions:{
        resetQuantity: function(){
            this.setStore({
                quantity: 1
            });
        },
        updateQuantity: function(quantity){
            this.setStore({
                quantity: quantity
            });
        },
        getDelivery: function(){
            var _this = this;

            var region = S('region')
            ,   baseData = this.getStore().goodData.baseData;
            console.log(region);
            var sku_id = baseData.goods_sku_id;

            var data = {
                'goods_sku_id': sku_id,
                'region_id': region.district
            };

            //运费直接设置为0
            _this.setStore({
                delivery_price: 0,
                delivery_region_id: region.district
            });

            if (baseData.production_type === constant.textile)
                return false

            // 计算运费
            webapi.goods.getDelivery(data).then(function(res){ // 请求运费
                if(res.code === 0){
                    _this.setStore({
                        delivery_price: res.data,
                        delivery_region_id: region.district
                    });
                }
            });
        },
        getGoodDetails: function(g_id) {
            var data = {'sid':g_id};
            var region = S('region');
            var _this = this;
            SP.loading(true);
            this.getAction().resetQuantity();
            webapi.goods.getGoodDetails(data).then(function (res) {
                SP.loading(false);
                if (res && res.code === 0) {
                    var good_detail = res.data;
                    var data = { 'goods_sku_id': good_detail.baseData.goods_sku_id ,'region_id': region.district};

                    // 99click 商品详情页统计
                    if(sipinConfig.env === "production"){
                        var _ozprm = "ID="+good_detail.baseData.sku_sn+"&CID="+(good_detail.category_id || 0);
                        liteFlux.event.emit('click99',"item",_ozprm );
                    }

                    // 保存当前 SKU 属性
                    var attribute_state = {};
                    var attribute_key = good_detail.baseData.attribute_key;
                    var attribute = attribute_key.split(',');
                    attribute.map(function(item){
                        var attr = item.split('-');
                        attribute_state[attr[0]] = parseInt(attr[1]);
                    });
                    var dataList = {
                        'goodData':good_detail ,
                        'delivery_price': 0 ,
                        'delivery_region_id': region.district ,
                        'attribute_key': attribute_state
                    };

                    // 家纺类不请求运费
                    if (good_detail.baseData.production_type === constant.textile) {
                        _this.setStore(dataList);
                        return
                    }

                    webapi.goods.getDelivery(data).then(function(res){ // 请求运费
                        dataList.delivery_price = res.data;

                        _this.setStore(dataList);
                    });
                }
                SP.loading(false);
            });
        }
    }
});

module.exports = store;
