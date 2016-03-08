###
# TouchSelector.
# @author remiel.
# @module TouchSelector
# @example TouchSelector
#
#   jsx:
#   <TouchSelector></TouchSelector>
#
# @param options {Object} the options
# @option
#
###
React = require 'react'
utils = require './utils'

TouchSelector = React.createClass
    displayName: 'TouchSelector'
    propsType:
        tagName: React.PropTypes.string
        component: React.PropTypes.element
        active: React.PropTypes.number
        duration: React.PropTypes.number
        onChange: React.PropTypes.func
        textKey: React.PropTypes.string

    getDefaultProps: () ->
        tagName: 'div'
        active: 0
        duration: 200
        textKey: "text"
        onChange: (value) ->
            console.log value

    getInitialState: ->

        @canceled = yes
        @xy = null
        @dx = null
        @dy = null
        @translateY = null
        @newTranslateY = null
        @transformProperty = utils.getProperty 'Transform'
        @transitionProperty = utils.getProperty 'Transition'

        animated: yes
        active: @props.active

    componentDidMount: ->
        # console.log 'cdm'
        @initValue()
        if @state.active
            @newTranslateY = -(+@state.active * @itemHeight)
        else
            @newTranslateY = 0
        @setTransform()

    componentWillReceiveProps: (nextProps) ->
        @initValue()
        @setState @getInitialState nextProps
        if nextProps.active
            @newTranslateY = -(+nextProps.active * @itemHeight)
        else
            @newTranslateY = 0
        @setTransform()
        @setState
            active: nextProps.active || 0



    render: ->
        # console.log 'render'
        classes = "touch-selector"
        style =
            outer:
                overflow: 'hidden'
            inner:
                overflow: 'hidden'
        Component = @props.component || @props.tagName
        <Component ref="outer" {...@props} className={classes} style={style.outer}>
            <div ref="inner" style={style.inner} onTouchStart={@handleTouchStart} onTouchEnd={@handleTouchEnd} onTouchCancel={@handleTouchEnd} onTouchMove={@handleTouchMove} onMouseDown={@handleMouseEvt} onMouseMove={@handleMouseEvt} onMouseUp={@handleMouseEvt} onMouseLeave={@handleMouseEvt}>
                {
                    @props.data.map (item, i) =>
                        itemClassName = 'item'
                        itemClassName += ' active' if @state.active is i
                        <div ref="item" key={i} className={itemClassName}>{item[@props.textKey]}</div>
                }
            </div>
            <div className="background"></div>
        </Component>

    getEls: () ->
        item = @refs.item
        outer: @refs.outer.getDOMNode()
        inner: @refs.inner.getDOMNode()
        item: if item then item.getDOMNode() else null

    initValue: () ->
        els = @getEls()
        @outerHeight = els.outer.offsetHeight
        @itemHeight = if els.item then els.item.offsetHeight else @itemHeight
        @innerPadding = @outerHeight/2 - @itemHeight/2
        els.inner.style['padding'] = @innerPadding + 'px 0'
        @innerHeight = els.inner.offsetHeight
        @dragRadius = @innerHeight - @outerHeight
        @canceled = !(@dragRadius >= 0)

    getTouchPosition: (e) ->
        touch = if e.touches then e.touches[0] else e
        x: touch.pageX
        y: touch.pageY

    setTransform: () ->
        els = @getEls()
        if utils.support.transform3d
            els.inner.style[@transformProperty] = 'translate3d(0,' + @newTranslateY + 'px' + ',0)'
        else
            els.inner.style[@transformProperty] = 'translate(0,' + @newTranslateY + 'px' + ')'

    handleTouchStart: (e)->
        # return 0 if e.touches.length isnt 1
        return 0 if e.pageX is undefined && e.touches.length isnt 1
        e.stopPropagation()
        e.preventDefault()
        return 0 if !@state.animated
        @setState
            animated: yes
            active: -1
        @canceled = no
        els = @getEls()
        @initValue()
        els.inner.style[@transitionProperty] = ''
        @xy = @getTouchPosition e
        @translateY = parseInt els.inner.style[@transformProperty].split(',')[1]
        @translateY = 0 if isNaN @translateY

    handleTouchEnd: (e)->
        e.stopPropagation()
        return 0 if !@state.animated
        if !@canceled and @xy isnt null
            @canceled = yes
            @xy = null
            els = @getEls()
            index = Math.round(@newTranslateY / @itemHeight)
            @newTranslateY = index * @itemHeight
            els.inner.style[@transitionProperty] = 'all ' + @props.duration + 'ms '
            @setState
                animated: no
                active: -index
            @setTransform()
            @props.onChange @props.data[-index]

            @timer = setTimeout ()=>
                els.inner.style[@transitionProperty] = ''
                @setState
                    animated: yes
            , @props.duration


    handleTouchMove: (e)->
        # console.log e.pageX
        return 0 if e.pageX is undefined && e.touches.length isnt 1
        e.stopPropagation()
        e.preventDefault()
        return 0 if !@state.animated
        els = @getEls()
        els.inner.style[@transitionProperty] = ''
        new_xy = @getTouchPosition e
        return 0 if !@xy
        @dx = new_xy.x - @xy.x
        @dy = new_xy.y - @xy.y

        if !@canceled
            @newTranslateY = @translateY + @dy
            @newTranslateY = 0 if @newTranslateY > 0
            @newTranslateY = -@dragRadius if @newTranslateY < -@dragRadius
            @setTransform()
            # index = Math.round(@newTranslateY / @itemHeight)
            # @setState
            #     active: -index

    handleMouseEvt: (e) ->
        switch e.type
            when 'mousedown'
                @handleTouchStart e
            when 'mousemove'
                @handleTouchMove e
            when 'mouseup'
                @handleTouchEnd e
            when 'mouseleave'
                @handleTouchEnd e



module.exports = TouchSelector
