###
# Horizontal Slider.
# @author remiel.
# @module Slider
# @example Slider
#
#   jsx:
#   <SliderHorizontal>
#       <img />
#       <img />
#       <img />
#   </SliderHorizontal>
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
        width = @state.width
        index = @state.active
        children = @props.children

        styles =
            inner:{}
        if width isnt null
            styles.inner =
                width: width * children.length + 'px'
            # 保证初始化的时候 定位到active不会出现滑动效果, 直接定位
            if @state.moved
                styles.inner[@transitionProperty] = 'all ' + @props.duration + 'ms '
            styles.inner[@transformProperty] = @getPosition()
        className = SP.classSet "slider",
            "full-screen": @props["full-screen"]
        <div ref="wrapper" className={className} onTouchMove={@preventDefault} onTouchStart={@preventDefault}>
            <Swiper ref="inner" onSwipe={@onSwipe} moveThreshold={4} minSwipeLength={10} className="slider-inner" style={styles.inner}>
                {@renderList(styles)}
            </Swiper>
            {@renderNavList()}
        </div>

    renderNavList: () ->
        index = @state.active
        children = @props.children

        if children and children.length
            node = React.Children.map children, (item, i) =>
                classes = SP.classSet
                    "slider-nav-item": yes
                    "active": i is index
                <Tappable key={i} className={classes} onTap={@jumpToIndex.bind(null, i)}></Tappable>

        classes = SP.classSet
            "slider-nav": yes
            "nav-at-center": @props['nav-center']
            "nav-at-right": @props['nav-right']
            "nav-gold": @props['nav-gold']
            "nav-gray": @props['nav-gray']
            "nav-square": @props['nav-square']
            "nav-square2": @props['nav-square2']

        <div className={classes}>
            {node}
        </div>
    renderList: (styles) ->
        width = @state.width
        index = @state.active
        children = @props.children

        if children and children.length
            React.Children.map children, (item, i) =>
                style =
                    width: width
                <div className="slider-item" style={style} key={i} >
                    {item}
                </div>

    initSize: () ->
        wrapper = @refs.wrapper.getDOMNode()
        width = wrapper.offsetWidth
        @setState
            width: width

    getPosition: () ->
        width = @state.width
        index = @state.active
        x = index * width
        @setTransform -x + 'px', 0, 0

    setTransform: (x, y, z) ->
        if utils.support.transform3d
            'translate3d(' + x + ',' + y + ',' + z + ')'
        else
            'translate(' + x + ',' + y + ')'

    onSwipe: (e) ->
        # if e.type is 'swipeUpLeft' or e.type is 'swipeUpRight' or e.type is 'swipeUp'
        #     @next()
        # if e.type is 'swipeDownLeft' or e.type is 'swipeDownRight' or e.type is 'swipeDown'
        #     @prev()
        if e.type is 'swipeUpLeft' or e.type is 'swipeDownLeft' or e.type is 'swipeLeft'
            @next()
            # @onSwipeLeft()
        if e.type is 'swipeUpRight' or e.type is 'swipeDownRight' or e.type is 'swipeRight'
            @prev()
            # @onSwipeRight()

    jumpToIndex: (value) ->
        width = @state.width
        children = @props.children
        length = children.length
        if width isnt null
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
        width = @state.width
        children = @props.children
        length = children.length
        if width isnt null
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
