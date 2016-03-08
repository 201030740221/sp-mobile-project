var moment = require('moment');
module.exports = {
	before: function(date){
		var startDiff = moment( date ).diff( moment(), 'seconds');
		if(startDiff > 0){
            return true;
        }
        return false;
	}
}