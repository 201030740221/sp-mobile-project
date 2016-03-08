React = require 'react'
Store = require 'stores/checkout'

SmsSetting = React.createClass
    onLinkChange: (type, value) ->
        data = {}
        data[type] = value
        Store.setStore data
        Store.getAction().check_mobile()

    render: ->
        store = Store.getStore()
        mobileLink =
            value: store['sms_mobile']
            requestChange: @onLinkChange.bind null, 'sms_mobile'
        error = store.fieldError
        <div className="sms-setting form-box u-mb-10">
            <header className="form-box-hd large-margin-top">
                定金支付
                <span className="u-color-gray-summary u-f12">(尾款需要<span className="u-color-blackred">{@props.data}</span>前支付)</span>
            </header>
            <Grid cols={24} className="form form-box-bd">
                <Col span={9} className="checkout-label u-color-gray-summary">尾款支付信息通知：</Col>
                <Col span={15}><Input type="text" valueLink={mobileLink}  placeholder="手机号码" /></Col>
                <div span={24} className="form-error-info u-mt-10">{if error and error['sms_mobile'] then error['sms_mobile'][0] else ''}</div>
            </Grid>
        </div>

module.exports = SmsSetting
