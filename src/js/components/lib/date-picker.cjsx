###
# DatePicker.
# @author remiel.
# @module DatePicker
# @example DatePicker
#
#   jsx:
#   <DatePicker initDate></DatePicker>
#
# @param props {Object} the props
# @option initDate {String} date
#
###
T = React.PropTypes

DatePicker = React.createClass

    propTypes:
        onChange: T.func
        onCancel: T.func
        initDate: T.string
        selected: T.string
        lastDate: T.string
        lastDays: T.number
        delay: T.number
        # checked: T.bool
        # type: T.string

    getDefaultProps: ->
        displayName: 'DatePicker'
        delay: 0
        lastDays: 30
        disabled:
            "1970-01-01": 1
        shortDayNames: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        onChange: (date)->

    getInitialState: ->
        @_initDates()
        dates = @_setDates @value, @props.delay
        dates: dates


    _initDates: ()->
        @initDate = @_parse @_format new Date(@props.initDate || new Date())
        @firstDate = @_ahead @initDate, @props.delay, 0
        if @props.lastDate
            @lastDate = new Date @props.lastDate
        else
            @lastDate = @_ahead @initDate, @props.delay + @props.lastDays, 0
        selected = new Date(@props.selected || @initDate)
        @value = @_format selected

    _setDates: (date, days)->
        date = @_parse date if typeof date is 'string'
        @startDate = @_ahead date, days, 0
        # 判断今天星期几 补全一周
        _startDay = @startDate.getDay()
        @startDate = @_ahead @startDate, -_startDay, 0 if _startDay isnt 0
        # 一周数据
        _dates = []
        for i in [0..6]
            date = @_ahead @startDate, i, 0
            fomateDate = @_format date
            type = if date.valueOf() > @lastDate.valueOf() then 1 else 0
            _obj =
                date: fomateDate
                day: @props.shortDayNames[date.getDay()]
                type: type
            # 补的日期不push
            _dates.push _obj if date.valueOf() >= @firstDate.valueOf() and date.valueOf() < @lastDate.valueOf()

        @active = 0
        _dates.map (item, i) =>
            if item.date is @value
                @active = i

        _dates

    _ahead: (date, days, months)->
        return new Date(
            date.getFullYear()
            date.getMonth() + months
            date.getDate() + days
        )

    _parse: (s)->
        if m = s.match /^(\d{4,4})-(\d{2,2})-(\d{2,2})$/
            return new Date m[1], m[2] - 1, m[3]
        else
            return null

    _format: (date)->
        month = (date.getMonth() + 1).toString()
        dom = date.getDate().toString()
        if month.length is 1
            month = '0' + month
        if dom.length is 1
            dom = '0' + dom
        return date.getFullYear() + '-' + month + "-" + dom

    prev: () ->
        dates = @_setDates @startDate, -7
        @value = dates[0].date
        @setState
            dates: dates

    next: () ->
        dates = @_setDates @startDate, 7
        @value = dates[0].date
        @setState
            dates: dates

    cancel: () ->
        @props.onCancel()

    ok: () ->
        @props.onChange @value

    onChange: (value) ->
        # console.log value
        @value = value.text.split(' ')[1]


    render: ->
        data = @state.dates.map (item, i) ->
            text: item.day + ' ' + item.date
            value: item.date

        classes =
            prev: SP.classSet
                "u-fl": true
                "u-none": @startDate.valueOf() <= (@_ahead @firstDate, -@firstDate.getDay(), 0).valueOf()
            next: SP.classSet
                "u-fr": true
                "u-none": (@_ahead @startDate, 7, 0).valueOf() >= @lastDate.valueOf()

        <div className="date-picker">
            <div className="lite-modal-hd">
                <Button bsStyle="icon" icon='arrowright' className={classes.prev} onTap={@prev}/>
                <Button bsStyle="icon" icon='arrowright' className={classes.next} onTap={@next}/>
                可选时间表
            </div>
            <TouchSelector data={data} onChange={@onChange} active={@active || 0}></TouchSelector>
            <div className="u-flex-box u-pl-15 u-pr-15 u-pb-10">
                <div className="u-flex-item-1 u-pr-5">
                    <Button block bsStyle='primary' onTap={@cancel}>取消</Button>
                </div>
                <div className="u-flex-item-1 u-pl-5">
                    <Button block bsStyle='primary' onTap={@ok}>确定</Button>
                </div>
            </div>
        </div>

module.exports = DatePicker
