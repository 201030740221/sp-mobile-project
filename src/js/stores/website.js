var store = liteFlux.store("website",{
    data: {
        bannerShow: true
    },
    actions:{
        getNewGoodsInformation: function() {
            var data = {
                page: 'm_index',
                version: 1
            };
            var _this = this;
            webapi.activity.getPageFrame(data).then(function (res) {
                if (res && res.code === 0) {
                   _this.setStore(res.data);
                }
            })
        }
    }
});

module.exports = store;
