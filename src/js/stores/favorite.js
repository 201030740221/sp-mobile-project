var store = liteFlux.store("favorite",{
    data: {

    },
    actions:{
        addGoodsFavorite: function(goods_id) {
            var data = {
                'goods_ids': JSON.stringify([goods_id])
            };
            var _this = this;
            webapi.member.favoriteAdd(data).then(function (res) {
                SP.requestProxy(res).then(function(){
                    var favorite_status = {'is_favorite':true};
                    _this.setStore(favorite_status);
                    SP.message({
                        msg: "添加收藏成功"
                    });
                });

            })
        },
        deleteGoodsFavorite: function(goods_id) {
            var data = {
                'goods_ids': JSON.stringify([goods_id])
            };
            var _this = this;
            webapi.member.favoriteDelete(data).then(function (res) {
                SP.requestProxy(res).then(function(){
                    var favorite_status = {'is_favorite':false};
                    _this.setStore(favorite_status);
                    SP.message({
                        msg: "取消收藏成功"
                    });
                });

            })
        }
    }
});

module.exports = store;
