###
# Touchmover.
# @author remiel.
# @module Touchmover
# @example Touchmover
#
#   jsx:
#   <Touchmover></Touchmover>
#
###
React = require 'react'
utils = require './utils'

Touchmover = React.createClass
    displayName: 'Touchmover'
    propsType:
        tagName: React.PropTypes.string
        component: React.PropTypes.element
        # minSwipeLength: React.PropTypes.number
        # moveThreshold: React.PropTypes.number
    getDefaultProps: () ->
        tagName: 'div'
        # minSwipeLength: 75
        # moveThreshold: 10
    getInitialState: ->

        @dx = null
        @dy = null
        @translateY = null
        @transformProperty = utils.getProperty 'Transform'

        direction: null
        initialTouch: null
        touch: null
        swipeStart: null

    componentDidMount: ->
        @initValue()


    render: ->
        classes = "touch-move-panel"
        style =
            outer:
                overflow: 'hidden'
            inner:
                overflow: 'hidden'
        Component = @props.component || @props.tagName
        <Component ref="outer" {...@props} className={classes} style={style.outer}>
            <div ref="inner" style={style.inner} onTouchStart={@handleTouchStart} onTouchEnd={@handleTouchEnd} onTouchCancel={@handleTouchEnd} onTouchMove={@handleTouchMove}>
                {@props.children}
            </div>
        </Component>

    getEls: () ->
        outer: @refs.outer.getDOMNode()
        inner: @refs.inner.getDOMNode()

    initValue: () ->
        els = @getEls()
        @dragRadius = els.inner.offsetHeight - els.outer.offsetHeight
        @canceled = !(@dragRadius >= 0)

    getTouchPosition: (e) ->
        touch = e.touches[0]
        x: touch.pageX
        y: touch.pageY

    handleTouchStart: (e)->
        return 0 if e.touches.length isnt 1
        e.stopPropagation()
        els = @getEls()
        @initValue()
        @xy = @getTouchPosition e
        @translateY = parseInt els.inner.style[@transformProperty].split(',')[1]
        @translateY = 0 if isNaN @translateY

    handleTouchEnd: (e)->
        e.stopPropagation()

    handleTouchMove: (e)->
        return 0 if e.touches.length isnt 1
        e.stopPropagation()
        e.preventDefault()
        els = @getEls()
        new_xy = @getTouchPosition e
        return 0 if !@xy
        @dx = new_xy.x - @xy.x
        @dy = new_xy.y - @xy.y


        if !@canceled
            newTranslateY = @translateY + @dy
            newTranslateY = 0 if newTranslateY > 0
            newTranslateY = -@dragRadius if newTranslateY < -@dragRadius
            if utils.support.transform3d
                els.inner.style[@transformProperty] = 'translate3d(0,' + newTranslateY + 'px' + ',0)'
            else
                els.inner.style[@transformProperty] = 'translate(0,' + newTranslateY + 'px' + ')'


module.exports = Touchmover
