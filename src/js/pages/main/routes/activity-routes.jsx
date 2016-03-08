module.exports = {
    activityJuly: function() {
        var ActivityJuly = require('pages/activity/july/index');
        return (
            <View>
                <ActivityJuly></ActivityJuly>
            </View>
        );
    },

    activityNovember: function() {
        var ActivityNovember = require('pages/activity/november/index');
        return (
            <View>
                <ActivityNovember></ActivityNovember>
            </View>
        );
    },

    activityNovemberTakeOff: function() {
        var ActivityNovemberTakeOff = require('pages/activity/november/takeOffIndex');
        return (
            <View>
                <ActivityNovemberTakeOff></ActivityNovemberTakeOff>
            </View>
        );
    },

    activityNovember4: function() {
        var Page = require('pages/activity/november/fourth/index');
        return (
            <View>
                <Page />
            </View>
        );
    }
};
