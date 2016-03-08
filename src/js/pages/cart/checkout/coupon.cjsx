###
# Coupon.
# @author remiel.
# @module Checkout
###
React = require 'react'

Coupon = React.createClass

    goToCoupon: (e) ->
        SP.redirect "/checkout/coupon"

    render: ->
        couponData = <span className="u-fr u-mr-30">{@props.data}优惠券</span> if @props.data

        <Tappable component="div"  className="form-box has-border-bottom border-indent-left" onTap={@goToCoupon}>
            <header className="form-box-hd large-padding">
                使用或激活优惠券
                {couponData}
                <Button bsStyle="icon" icon='arrowright' />
            </header>
        </Tappable>

module.exports = Coupon
