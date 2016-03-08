###
# Total.
# @author remiel.
# @module Checkout
###
React = require 'react'

Total = React.createClass

    render: ->
        data = @props.data
        if data.total_price?
            totalText = ''
            total = ''
            if @props.showTotal
                totalText = <div className="u-f14 u-mt-5">总计：</div>
                total = <div className="u-f14 u-color-blackred u-mt-5">￥{data.total}</div>
            <div className="form-box checkout-total u-mb-10">
                <div className="form-box-hd">
                    <table className="u-f12">
                        <tr>
                            <td>
                                <div className="u-f14">
                                    <span className="u-color-blackred">{data.total_amount}</span> 件商品
                                </div>
                            </td>
                            <td>
                                <div className="u-f14 u-mb-5">小计：</div>
                                <div>运费：</div>
                                <div>安装费：</div>
                                <div>送装费用减免：</div>
                                <div>优惠券：</div>
                                {totalText}
                            </td>
                            <td>
                                <div className="u-f14 u-mb-5">￥{data.total_price}</div>
                                <div>￥{data.total_delivery}</div>
                                <div>￥{data.total_installation}</div>
                                <div>-￥{(SP.calc.Add(data.delivery_abatement || 0,data.installation_abatement || 0, 2)).toFixed(2)}</div>
                                <div>-￥{data.coupon_abatement}</div>
                                {total}
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        else
            <span></span>

module.exports = Total
