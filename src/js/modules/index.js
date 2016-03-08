var assign = require('object-assign');

var components = assign(
    {
        ModulesMixins: require('./lib/mixins/index'),
        Filter: require('./lib/filter'),
        // 商品单项
        GoodsItem: require('./lib/goods-item'),
        Empty: require('./lib/empty'),
        CompletePage: require('./lib/complete-page'),
        // 购物车按钮
        LiteCart: require('./lib/lite-cart'),
        // 加入购物车按钮
        AddToCart: require('./lib/add-to-cart'),
        // 新地址
        LiteNewAddress: require('./lib/lite-new-address'),
        // 兑换商品加入购物车按钮
        ExchangeToCart: require('./lib/exchange-to-cart'),
        // 商品地区选择
        RegionView: require('./lib/region-view')
    }
);

module.exports = components;
