module.exports = {
    goodDetail: function(id) {
        var GoodDetail = require('pages/goods/detail/detail');

        return (
            <View>
                <GoodDetail id={id}></GoodDetail>
            </View>
        );
    },

    goodMoreDetail: function(id) {
        var GoodMoreDetail = require('pages/goods/detail/more-detail');
        return (
            <View>
                <GoodMoreDetail id={id}></GoodMoreDetail>
            </View>
        );
    },

    flashsaleMoreDetail: function(id) {
        var FlashsaleMoreDetail = require('pages/goods/flash-sale/more-detail');
        return (
            <View>
                <FlashsaleMoreDetail id={id}></FlashsaleMoreDetail>
            </View>
        );
    },

    flashsale: function(id) {
        var FlashSaleDetail = require('pages/goods/flash-sale/detail');
        return (
            <View>
                <FlashSaleDetail id={id}></FlashSaleDetail>
            </View>
        );
    },

    goodsList: function(id) {
        var GoodList = require('pages/goods/list/list');
        return (
            <View>
                <GoodList id={id} type="view"></GoodList>
            </View>
        );
    },
    goodsSearch: function(keyword) {
        var GoodList = require('pages/goods/list/list');
        return (
            <View>
                <GoodList keyword={keyword} type="search"></GoodList>
            </View>
        );
    },
    searchIndex: function(type) {
        var SearchList = require('pages/goods/search/search');
        return (
            <View>
                <SearchList type={type}></SearchList>
            </View>
        );
    },
    commentIndex: function(id) {
        var CommentIndex = require('pages/goods/comment/index');
        return (
            <View>
                <CommentIndex id={id}></CommentIndex>
            </View>
        );
    }
};
