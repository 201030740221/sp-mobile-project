module.exports = {
    shareWeixin: function(url) {
        var ShareWeixin = require('pages/share/weixin');
        return (
            <View>
                <ShareWeixin url={url}/>
            </View>
        );
    }
};
