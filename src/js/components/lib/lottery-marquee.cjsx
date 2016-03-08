###
# Marquee.
# @author remiel.
# @module lottery
###
T = React.PropTypes

Marquee = React.createClass
    propTypes:
        data: T.array
        start: T.func
        callback: T.func
        contentType: T.string
        rule: T.string

    getDefaultProps: ->
        data: []
        contentType: 1
        rule: '规则'
        start: () ->
            # console.log ''
        callback: () ->
            # console.log ''

    getInitialState: ->
        active: -1
        drawing: no
        hasResult: no
        count: 0
        delay: 100

    componentWillReceiveProps: (props) ->
        if props.result is -1
            console.log  -1
            @clearTimeout()
            @callbackClearTimeout()
            @setState
                hasResult: no
                drawing: no
                count: 0
                delay: 100

        else if props.result isnt null
            @setState
                hasResult: yes
                drawing: no
        else
            @setState
                hasResult: no

    componentWillUnmount: ->
        @clearTimeout()
        @callbackClearTimeout()

    renderList: () ->
        if @props.data is null
            return <Loading inside/>

        row1 =
            <div className="lottery-marquee-row lottery-marquee-row-1" key={1}>
                {@renderRow(1)}
            </div>

        row2 =
            <div className="lottery-marquee-row lottery-marquee-row-2" key={2}>
                {@renderRow(2)}
                {@renderContent()}
            </div>

        row3 =
            <div className="lottery-marquee-row lottery-marquee-row-3" key={3}>
                {@renderRow(3)}
            </div>
        [row1, row2, row3]


    renderRow: (n) ->
        data = @props.data
        node = []
        switch n
            when 1 then data.map (item, i) =>
                node.push @renderItem(item, i) if i < 2
            when 2 then data.map (item, i) =>
                node.push @renderItem(item, i) if i is 2 or i is 5
            when 3 then data.map (item, i) =>
                node.push @renderItem(item, i) if i is 3 or i is 4
        node


    renderItem: (item, i) ->
        className = SP.classSet
            "lottery-marquee-item": yes
            "active": i is @state.active
        className = SP.classSet className, "lottery-marquee-item-" + i
        url = if typeof item.pics is 'object' then item.pics.mobile else ''
        <div className={className} key={i}>
            <div className="lottery-marquee-item-inner">
                <img src={url} w={100} h={100} />
            </div>
        </div>

    renderContent: () ->
        btnClassName = SP.classSet "lottery-marquee-btn",
            "disabled": not (@state.hasResult is no and @state.drawing is no) or not (@props.times > 0) or @props.begin isnt yes or @props.end isnt yes
        btnText = if (@state.hasResult is no and @state.drawing is no) then "点击抽奖" else "正在抽奖中"
        type = @props.contentType
        if not @props.isLogin
            switch type
                when '2'
                    node =
                        <div className="lottery-marquee-content-inner">
                            <Tappable className="lottery-marquee-btn" onTap={@props.login}>马上登录</Tappable>
                            <div className="u-mt-15">{@renderRule()}</div>
                        </div>
                else
                    node =
                        <div className="lottery-marquee-content-inner">
                            <div className="u-f14">登录签到</div>
                            <div className="u-f14">
                                获取抽奖机会
                            </div>
                            <Tappable className="lottery-marquee-btn" onTap={@props.login}>登录抽奖</Tappable>
                        </div>
        else if @props.times is null
            node = <Loading inside/>
        else if @props.begin isnt yes
            switch type
                when '2'
                    node =
                        <div className="lottery-marquee-content-inner">
                            <Tappable className={btnClassName}>活动未开始</Tappable>
                            <div className="u-mt-15">{@renderRule()}</div>
                        </div>
                else
                    node =
                        <div className="lottery-marquee-content-inner u-f14">
                            <span>抽奖活动未开始</span>
                        </div>
        else if @props.end isnt yes
            switch type
                when '2'
                    node =
                        <div className="lottery-marquee-content-inner">
                            <Tappable className={btnClassName}>活动已结束</Tappable>
                            <div className="u-mt-15">{@renderRule()}</div>
                        </div>
                else
                    node =
                        <div className="lottery-marquee-content-inner u-f14">
                            <span>抽奖活动已结束</span>
                        </div>
        else
            switch type
                when '2'
                    node =
                        <div className="lottery-marquee-content-inner">
                            <Tappable className={btnClassName} onTap={@start} >{btnText}</Tappable>
                            <div className="u-mt-15">{@renderRule()}</div>
                        </div>
                else
                    node =
                        <div className="lottery-marquee-content-inner">
                            <div className="u-f14">今日剩抽奖机会</div>
                            <div className="u-f14">
                                <span className="u-f20 u-color-red">{@props.times}</span>
                                次
                            </div>
                            <Tappable className={btnClassName} onTap={@start} >{btnText}</Tappable>
                        </div>
        <div className="lottery-marquee-content">
            {node}
        </div>

    renderRule: () ->
        rule = @props.rule || ''
        rule =
            __html: rule
        rule =
            <div className="u-pt-30 u-pr-15 u-pl-15">
                <div className="u-f14 u-mb-15">抽奖规则</div>
                <div className="u-color-gray-summary" dangerouslySetInnerHTML={rule}>
                </div>
            </div>
        <Alertable className="u-f12 u-color-gray-summary" showConfirmBtn={no} showCloseIcon={yes} contentElement={rule} margun={15}>抽奖规则</Alertable>

    start: () ->
        if @state.hasResult is no and @state.drawing is no and @props.times > 0
            # console.log 'start'
            @props.start()
            @setState
                active: 0
                drawing: yes
                count: @props.data.length * 2
            setTimeout () =>
                @setTimeout()
            ,20

    change: () ->
        data = @props.data
        len = data.length
        active = @state.active + 1
        if active >= len
            active = 0
        # switch active
        #     when 3 then active = 5
        #     when 6 then active = 4
        #     when 5 then active = 3
        #     when 4 then active = 0
        @setState
            active: active
            delay: @state.delay + 2
        @setTimeout()

    changeToResult: () ->
        data = @props.data
        len = data.length
        result = @props.result
        count = @state.count
        delay = @state.delay
        active = @state.active + 1
        if active >= len
            active = 0
        # switch active
        #     when 3 then active = 5
        #     when 6 then active = 4
        #     when 5 then active = 3
        #     when 4 then active = 0

        # console.log @state, @props
        if count is 0
            if result isnt @props.data[active].id
                @setState
                    active: active
                    drawing: no
                    delay: delay + 120
                @setTimeout()
            else
                @setState
                    active: active
                @callbackSetTimeout()
        else
            @setState
                active: active
                drawing: no
                count: count - 1
                delay: delay + 30
            @setTimeout()

    callbackSetTimeout: () ->
        @callbackTimer = setTimeout () =>
            @props.callback()
            @setState
                drawing: no
                count: 0
                delay: 100
        , 2500

    callbackClearTimeout: () ->
        clearTimeout @callbackTimer


    setTimeout: () ->
        # console.log @state.drawing, @state.hasResult
        @clearTimeout()
        if @state.drawing is no and @state.hasResult is yes
            @timer = setTimeout ()=>
                @changeToResult()
            , @state.delay
        else if @state.drawing is yes
            @timer = setTimeout ()=>
                @change()
            , @state.delay

    clearTimeout: () ->
        clearTimeout @timer

    renderBorder: (n) ->
        for i in [1..n]
            <i key={i}></i>

    render: ->
        className = SP.classSet "lottery-marquee-main",
            "active": not (@state.hasResult is no and @state.drawing is no)
        <div className={className}>
            <div className="lottery-marquee-list">
                <div className="lottery-marquee-border lottery-marquee-top">
                    {@renderBorder(19)}
                </div>
                <div className="lottery-marquee-border lottery-marquee-bottom">
                    {@renderBorder(19)}
                </div>
                <div className="lottery-marquee-border lottery-marquee-left">
                    {@renderBorder(19)}
                </div>
                <div className="lottery-marquee-border lottery-marquee-right">
                    {@renderBorder(19)}
                </div>
                {@renderList()}
            </div>
        </div>

module.exports = Marquee
