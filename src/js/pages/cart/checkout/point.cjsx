###
# Point
# @author remiel.
# @module Checkout
###
Point = React.createClass
    mixins: [liteFlux.mixins.storeMixin('checkout')]
    onChange: () ->
        A('checkout').onChange !@props.data.point_state, 'point_state'

    render: ->

        data = @props.data
        text = ''
        available_point = SP.calc.Sub data.available_point || 0, data.data.price.total_point || 0
        if data.point_state and available_point is 0
            text = <span className="u-fr checkout-point-text u-color-gray-summary">暂无积分可用</span>
        if data.point_state and available_point > 0
            # point_abatement = 0
            # if data.data.price.point_abatement
            #     point_abatement = data.data.price.point_abatement
            # total = SP.calc.Add data.data.price.total, point_abatement
            # total = 0 if total < 0
            # total = SP.calc.Mul total, 100
            # total = available_point if total > available_point
            total = A('checkout').getUsedPoint()
            total = (SP.calc.Div total, 100).toFixed(2)
            text = <span className="u-fr checkout-point-text u-color-gray-summary">共{available_point}积分，抵扣<span className="u-color-gold">{total}</span>元</span>

        <div className="form-box checkout-nav has-border-bottom checkout-point">
            <header className="form-box-hd large-padding">
                使用积分
                {text}
                <Checkbox checked={data.point_state} onChange={@onChange} type='switch'></Checkbox>
            </header>
        </div>

module.exports = Point
