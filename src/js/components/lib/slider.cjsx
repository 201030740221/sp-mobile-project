###
# Slider.
# @author remiel.
# @module Slider
# @example Slider
#
#   jsx:
#   <Slider data={[]}></Slider>
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
        # type: T.number
        duration: T.number
        data: T.array
        auto: T.bool
        delay: T.number
        h: T.number
        w: T.number

    getDefaultProps: ->
        # type: 0
        duration: 200
        data: []
        auto: yes
        delay: 5000

    getInitialState: ->
        @transformProperty = utils.getProperty 'Transform'
        @transitionProperty = utils.getProperty 'Transition'
        width: null
        active: 0


    componentDidMount: ->
        @initSize()
        if @props.auto is yes
            @autoPlay()

    componentWillUnmount: ->
        @cancelAutoPlay()

    renderNavList: () ->
        data = @props.data
        index = @state.active

        if data and data.length
            node = data.map (item, i) ->
                classes = SP.classSet
                    "slider-nav-item": yes
                    "active": i is index
                <Tappable key={i} className={classes}></Tappable>

        classes = SP.classSet
            "slider-nav": yes
            "nav-at-center": @props['nav-center']
            "nav-at-right": @props['nav-right']
            "nav-gold": @props['nav-gold']
            "nav-gray": @props['nav-gray']

        <div className={classes}>
            {node}
        </div>


    render: ->

        width = @state.width
        index = @state.active
        data = @props.data
        if width isnt null
            styles =
                inner:
                    width: width * data.length + 'px'

                item:
                    width: width

            styles.inner[@transitionProperty] = 'all ' + @props.duration + 'ms '
            styles.inner[@transformProperty] = @setTransform -index * width + 'px', 0, 0
        else
            styles =
                inner:{}
                item:{}

        <div ref="wrapper" className="slider" onTouchMove={@preventDefault} onTouchStart={@preventDefault}>
            <Swiper ref="inner" onSwipe={@onSwipe} moveThreshold={4} minSwipeLength={10} className="slider-inner" style={styles.inner}>
                {@renderList(styles)}
            </Swiper>
            {@renderNavList()}
        </div>

    renderList: (styles) ->
        self = this
        data = @props.data

        if data.length
            data.map (item, i) =>
                url = item.url || ''
                beforeAction = ->
                # 99click 广告统计
                if self.props.banner
                    name = '__ad_frame_' + item.frame_id + '_' + item.ad_id + '_' + item.ad_type
                    beforeAction = ->
                        if sipinConfig.env == "production"
                            liteFlux.event.emit 'click99',"click", name

                <Link beforeAction={beforeAction} className="slider-item" name={name} href={url} style={styles.item} key={i}>
                    <Img src={item.img} w={@props.w} h={@props.h}/>
                </Link>

    initSize: () ->
        wrapper = @refs.wrapper.getDOMNode()
        wrapperWidth = wrapper.offsetWidth
        @setState
            width: wrapperWidth

    setTransform: (x, y, z) ->
        if utils.support.transform3d
            'translate3d(' + x + ',' + y + ',' + z + ')'
        else
            'translate(' + x + ',' + y + ')'

    onSwipeLeft: (e) ->
        @setActiveIndex 1

    onSwipeRight: (e) ->
        @setActiveIndex -1

    onSwipe: (e) ->
        if e.type is 'swipeUpLeft' or e.type is 'swipeDownLeft' or e.type is 'swipeLeft'
            @onSwipeLeft()
        if e.type is 'swipeUpRight' or e.type is 'swipeDownRight' or e.type is 'swipeRight'
            @onSwipeRight()

    setActiveIndex: (value) ->
        width = @state.width
        if width isnt null
            index = @state.active
            index += value
            if index >= 0 and index < @props.data.length
                @setState
                    active: index
            else if index >= @props.data.length
                @setState
                    active: 0
            else
                @setState
                    active: @props.data.length - 1


    next: () ->
        width = @state.width
        if width isnt null
            index = @state.active
            index += 1
            if index >= 0 and index < @props.data.length
                @setState
                    active: index
            else
                @setState
                    active: 0

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
        # e.preventDefault()
        @autoPlay()








module.exports = Slider
