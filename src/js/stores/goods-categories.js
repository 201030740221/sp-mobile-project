var store = liteFlux.store("categories",{
    data: {

    },
    actions:{
        getGoodsCategories: function() {
            var _this = this;
            SP.loading(true);
            webapi.goods.getGoodsCategories().then(function (res) {
                SP.loading(false);
                if (res && res.code === 0) {
                    _this.setStore({
                        'categories': res.data
                    });
                }
            })
        }
    }
});

module.exports = store;
