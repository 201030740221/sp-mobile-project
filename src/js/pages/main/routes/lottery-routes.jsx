module.exports = {
    lottery: function(id) {
        var Lottery = require('pages/lottery/lottery');
        return (
            <View>
                <Lottery id={id}/>
            </View>
        );
    }
};
