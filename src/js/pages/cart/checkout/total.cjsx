###
# Total.
# @author remiel.
# @module Checkout
###
React = require 'react'

Total = React.createClass
    render: ->
        data = @props.data

        # 预售订单
        if data.type is 1
            presaleTotalPrice = null # 总计
            presalePrice = null # 小计
            presalePriceText = null

            switch data.presale_status
                when 0
                    presaleTotalPrice = data.earnest_money
                    presalePrice = data.earnest_money
                    presalePriceText = <span className="total-badge">定金</span>
                when 1
                    presaleTotalPrice = data.balance_due
                    presalePrice = SP.calc.Sub data.total_price, data.earnest_money
                    presalePriceText = <span className="total-badge">尾款</span>

            presaleTip = <p className="u-color-gray-summary u-pt-10">注：运费、安装费在尾款阶段支付，且您下单使用的优惠券将在尾款支付阶段抵扣</p>

        if data.total_price?
            abatement = "0.00"
            if data.delivery_abatement and data.installation_abatement
                delivery_abatement = data.delivery_abatement || 0
                installation_abatement = data.installation_abatement || 0
                abatement = SP.calc.Add delivery_abatement, installation_abatement, 2
            abatement = abatement.toFixed(2)
            totalText = ''
            total = ''
            if @props.showTotal
                totalText = <div className="u-f14 u-mt-5">总计：</div>
                total = <div className="u-f14 u-color-blackred u-mt-5">￥{if presaleTotalPrice? then presaleTotalPrice else data.total}</div>
            if @props.showGetPoint
                getPointText = <div className="u-mt-5">将获得积分：</div>
                getPoint = <div className="u-color-gold u-mt-5">{Math.ceil data.total}</div>

            <div className="form-box checkout-total u-mb-10">
                <div className="form-box-hd">
                    <table className="u-f12">
                        <tr>
                            <td>
                                <div className="u-f14">
                                    <span className="u-color-blackred">{parseInt data.total_amount}</span> 件商品
                                </div>
                            </td>
                            <td>
                                <div className="u-f14 u-mb-5">小计：</div>
                                <div>运费：</div>
                                {<div>安装费：</div> if data.total_installation > 0}
                                {<div>送装费用减免：</div> if abatement > 0}
                                {<div>优惠券：</div> if data.coupon_abatement > 0}
                                {<div>积分抵扣：</div> if data.point_abatement > 0}
                                {<div>积分兑换：</div> if data.total_point > 0}
                                {totalText}
                                {getPointText}
                            </td>
                            <td>
                                <div className="u-f14 u-mb-5">
                                    {presalePriceText}
                                    ￥{if presalePrice? then presalePrice else data.total_price}
                                </div>
                                <div>￥{data.total_delivery}</div>
                                {<div>￥{data.total_installation}</div> if data.total_installation > 0}
                                {<div>-￥{abatement}</div> if abatement > 0}
                                {<div>-￥{data.coupon_abatement}</div> if data.coupon_abatement > 0}
                                {<div>-￥{data.point_abatement || '0.00'}</div> if data.point_abatement > 0}
                                {<div>{data.total_point || 0}</div> if data.total_point > 0}
                                {total}
                                {getPoint}
                            </td>
                        </tr>
                    </table>
                    {if presaleTip? then presaleTip else null}
                </div>
            </div>
        else
            <span></span>

module.exports = Total
