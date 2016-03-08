# /**
#  * 一个视图窗口，用于 Body > View，当有多个可切换页面的情况时候使用
#  * onPushRefresh: 下拉刷新
#  * onPullRefresh: 上拉刷新 @TODO
#  * @type {[type]}
#  */
React = require('react')
Events = require('utils/events')

View = React.createClass
    propTypes:
        'onPushRefresh': React.PropTypes.func,
        'canRefresh': React.PropTypes.func

    getDefaultProps: ()->
            # 'onPushRefresh': null,
            # 'canRefresh': ()->return false}

    getInitialState: ()->
        'loaded': no

    componentWillReceiveProps: (props) ->
        @offEvt()
        @init()
        @onEvt() if(props.onPushRefresh and props.canRefresh)

    componentDidMount: ()->
        @init()
        @onEvt() if(@props.onPushRefresh and @props.canRefresh)

    componentWillUnmount: ()->
        @offEvt()

    loaded: (isLoaded)->
        @setState
            'loaded': isLoaded
    init: ()->
        @page = React.findDOMNode @

        # /* @TODO 复杂的加载判断，或许可以优化 */
        @maxH = 100 # pushup 区域最大高度

        # @currPosY # 触摸移动的当前位置
        # @movePosY  # 触摸移动的实时位置，结合currPosY可以判断出是上拉还是下拉
        # @isUping # 上拉判断
        # @isDowning # 下拉判断
        #
        # @pageMovePos  # 容器底部被移动的绝对距离 = 滚动高度+自身高度
        # @originPageH  # 触摸开始，记录当前容器原始高度，用于避免 pushup 引起的高度变化
        #
        # @upingStart  # 到达底部，开始上拉的起点位置记录
        # @downingStart # 转为下拉的起点位置记录
        # @_height

    offEvt: ()->
        Events.off @page, 'scroll', @scroll
        Events.off @page, 'touchstart', @touchstart
        Events.off @page, 'touchmove', @touchmove
        Events.off @page, 'touchend', @touchend
    onEvt: ()->
        @offEvt()
        if @props.onscroll
            Events.on @page, 'scroll', @scroll
        Events.on @page, 'touchstart', @touchstart
        Events.on @page, 'touchmove', @touchmove
        Events.on @page, 'touchend', @touchend

    touchstart: (e) ->
        if not @props.canRefresh()
            return @loaded yes
        @loaded no

        @currPosY = e.touches[0].screenY
        @originPageH = @page.offsetHeight

    touchmove: (e) ->
        # if (! @props.canRefresh()) {
        #     return @loaded yes
        # }
        # @loaded no

        pushup = React.findDOMNode @refs.pushup

        @movePosY = e.touches[0].screenY
        @isUping = @currPosY > @movePosY
        @isDowning = @currPosY < @movePosY

        @currPosY = @movePosY;
        @pageMovePos = @page.scrollTop + @originPageH;

        if @isUping and @pageMovePos >= @page.scrollHeight
            @upingStart = @upingStart || @movePosY;
            @downingStart = null;
            @_height = Math.min(@maxH, Math.abs(@movePosY - @upingStart));
            pushup.style.height = @_height + 'px';
            if @_height is @maxH
                e.preventDefault()

        if (@isDowning and @pageMovePos <= @page.scrollHeight)
            @upingStart = null
            @downingStart = @downingStart || @movePosY;

            pushup.style.height = Math.max(0,  pushup.offsetHeight - (@movePosY - @downingStart)) + 'px';

    touchend: (e) ->
        if not @props.canRefresh()
            return @loaded yes
        @loaded no
        pushup = React.findDOMNode @refs.pushup

        @upingStart = null;
        if pushup.offsetHeight
            # 达到一定高度，松手加载，否则不加载
            pushup.offsetHeight > @maxH / 1.5 and @props.onPushRefresh.call @page, ()->
                # 调用方在数据加载完毕后，调用回调，隐藏加载提示
                pushup.style.height = '0'

    scroll: (e) ->
        @props.onscroll.call(@page, e)

    render: ()->
        isPushRefresh = !!@props.onPushRefresh;

        classMap =
            'page-content': yes
            'push-refresh': isPushRefresh


        classes = SP.classSet classMap, @props.className

        pushLoding = ''

        classRefresh = SP.classSet
            'push-refresh-tip': yes
            'loaded': @state.loaded

        if isPushRefresh
            pushLoding = <div className={classRefresh} ref="pushup"></div>

        <div {...@props} className={classes}>
            {@props.children}
            {pushLoding}
        </div>

module.exports = View;
