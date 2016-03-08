###
# Coupon.
# @author remiel.
# @module Checkout
###
React = require 'react'

Coupon = React.createClass

    goToCoupon: (e) ->
        SP.redirect "/checkout/service-card"

    render: ->
        if @props.data
            text = <span className="u-fr u-mr-30">已使用</span>
        <Tappable component="div"  className="form-box has-border-bottom border-indent-left" onTap={@goToCoupon}>
            <header className="form-box-hd large-padding">
                使用安装卡
                {text}
                <Button bsStyle="icon" icon='arrowright' />
            </header>
        </Tappable>

module.exports = Coupon
