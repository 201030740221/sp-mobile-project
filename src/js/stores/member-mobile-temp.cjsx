liteFlux = require('lite-flux')

store = liteFlux.store "member-mobile-temp",
    data:
        account: ''
        sms_code: '',
        referral_code: null

module.exports = store;
