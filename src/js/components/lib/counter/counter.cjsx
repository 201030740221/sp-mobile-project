###
# Counter.
# @author remiel.
# @widget Counter
# @example Counter
#
#   jsx:
#   <Counter max='99' min='1' current="10" delay="500"></Counter>
#
# @param options
# @option callback {Function} callback with the value if change
# @option max {Number} max
# @option min {Number} min
# @option current {Number} init value
# @option delay {Number} the callback's delay
#
###

React = require 'react'
Tappable = require 'react-tappable'

T = React.PropTypes

Counter = React.createClass
    propsType:
        callback: T.func
        max: T.number
        min: T.number
        current: T.number
        delay: T.number

    getDefaultProps: ->
        callback: (current) ->
            console.log current
        max: 9999
        min: 1
        current: 1
        delay: 0

    getInitialState: ->
        @timer = null
        current: @props.current

    componentWillReceiveProps: (props) ->
        @setState
            current: props.current

    onClick: (e) ->
        el = e.target
        data = el.dataset
        type = data.type
        current = @state.current
        switch type
            when 'up'
                current++ if current < @props.max
            when 'down'
                current-- if current > @props.min
        if current isnt +@state.current
            @setValue current
    onChange: (e) ->
        el = e.target
        value = el.value
        current = @state.current

        if isNaN +value
            console.log '输入有误'
        else
            if value is ''
                value = @props.min

            if +value >= @props.min and +value <= @props.max
                current = +value
                @setValue current


    setValue: (value) ->
        @setState
            current: value
        clearTimeout @timer
        @timer = setTimeout =>
            @props.callback.call @, value
        , @props.delay

    onFocus: (e) ->
        el = @refs.ipt.getDOMNode()
        el.blur()

    render: ->
        current = @state.current
        downClass = 'down icon icon-subtraction'
        downClass += ' disabled' if current <= @props.min
        upClass = 'up icon icon-addition'
        upClass += ' disabled' if current >= @props.max

        <div className='counter'>
            <Tappable className={downClass} data-type="down" onTap={@onClick}></Tappable>
            <input ref="ipt" type="text" value={current} onChange={@onChange} onFocus={@onFocus}/>
            <Tappable className={upClass} data-type="up" onTap={@onClick}></Tappable>
        </div>


module.exports = Counter
