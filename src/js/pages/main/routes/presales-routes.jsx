module.exports = {
    presalesHome: function(id) {
        var Page = require('pages/presales/home/home');

        return (
            <View>
                <Page />
            </View>
        );
    },

    presalesDetail: function(id) {
        var Page = require('pages/presales/detail/detail');
        return (
            <View>
                <Page id={id} />
            </View>
        );
    },

    presalesGuide: function() {
        var Page = require('pages/presales/guide/guide');
        return (
            <View>
                <Page/>
            </View>
        );
    }
};
