###
# Vertical Slider.
# @author remiel.
# @module Slider
# @example Slider
#
#   jsx:
#   <SliderVertical>
#       <img />
#       <img />
#       <img />
#   </SliderVertical>
#
# @param options {Object} the options
# @option data {Array}
#
###
React = require 'react'
utils = require './touch-panel/utils'
WindowListenable = require './mixins/window-listenable'
T = React.PropTypes

Slider = React.createClass
    mixins: [WindowListenable]

    windowListeners:
        'resize': 'initSize'

    propTypes:
        duration: T.number
        auto: T.bool
        delay: T.number
        active: T.number
        nav: T.bool
        "full-screen": T.bool

    getDefaultProps: ->
        # type: 0
        duration: 200
        auto: no
        delay: 5000
        active: 0

    getInitialState: ->
        @transformProperty = utils.getProperty 'Transform'
        @transitionProperty = utils.getProperty 'Transition'
        width: null
        active: @props.active || 0
        moved: no


    componentDidMount: ->
        @initSize()
        if @props.auto is yes
            @autoPlay()

    componentWillUnmount: ->
        @cancelAutoPlay()

    render: ->
        height = @state.height
        index = @state.active
        children = @props.children

        styles =
            inner:{}
        if height isnt null
            styles.inner =
                height: height * children.length + 'px'
            # 保证初始化的时候 定位到active不会出现滑动效果, 直接定位
            if @state.moved
                styles.inner[@transitionProperty] = 'all ' + @props.duration + 'ms '
            styles.inner[@transformProperty] = @getPosition()
        className = SP.classSet "slider vertical",
            "full-screen": @props["full-screen"]
        <div ref="wrapper" className={className} onTouchMove={@preventDefault} onTouchStart={@preventDefault}>
            <Swiper ref="inner" onSwipe={@onSwipe} moveThreshold={4} minSwipeLength={10} className="slider-inner" style={styles.inner}>
                {@renderList(styles)}
            </Swiper>
        </div>

    renderList: (styles) ->
        height = @state.height
        index = @state.active
        children = @props.children

        if children and children.length
            React.Children.map children, (item, i) =>
                style =
                    height: height
                <div className="slider-item" style={style} key={i} >
                    {item}
                </div>

    initSize: () ->
        wrapper = @refs.wrapper.getDOMNode()
        height = wrapper.offsetHeight
        @setState
            height: height

    getPosition: () ->
        height = @state.height
        index = @state.active
        x = index * height
        @setTransform 0, -x + 'px', 0

    setTransform: (x, y, z) ->
        if utils.support.transform3d
            'translate3d(' + x + ',' + y + ',' + z + ')'
        else
            'translate(' + x + ',' + y + ')'

    onSwipe: (e) ->
        if e.type is 'swipeUpLeft' or e.type is 'swipeUpRight' or e.type is 'swipeUp'
            @next()
        if e.type is 'swipeDownLeft' or e.type is 'swipeDownRight' or e.type is 'swipeDown'
            @prev()

    jumpToIndex: (value) ->
        height = @state.height
        children = @props.children
        length = children.length
        if height isnt null
            if isNaN value
                index = 0
            else
                index = value
            if index >= 0 and index < length
                @setState
                    active: index
                    moved: yes
            else if index >= length
                @setState
                    active: length - 1
                    moved: yes
            else
                @setState
                    active: 0
                    moved: yes

    setActiveIndex: (value) ->
        height = @state.height
        children = @props.children
        length = children.length
        if height isnt null
            index = @state.active
            index += value
            if index >= 0 and index < length
                @setState
                    active: index
                    moved: yes
            else if index >= length
                @setState
                    active: 0
                    moved: yes
            else
                @setState
                    active: length - 1
                    moved: yes

    next: () ->
        @setActiveIndex 1

    prev: () ->
        @setActiveIndex -1

    autoPlay: () ->
        @cancelAutoPlay()
        @autoTimer = setTimeout () =>
            index = @state.active
            @next()
            @autoPlay()
        , @props.delay

    cancelAutoPlay: () ->
        clearTimeout @autoTimer


    preventDefault: (e) ->
        # 暂时取消. TODO:加入x,y判断
        e.preventDefault() if @props.preventDefault
        @autoPlay() if @props.auto


module.exports = Slider
