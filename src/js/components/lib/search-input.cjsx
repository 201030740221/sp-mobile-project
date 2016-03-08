###
# 搜索框
# @author tofishes
###
Search = React.createClass
    getDefaultProps: ->
        return {
            onChange: ->
            suggestionSpeed: 300
            disableSuggestion: false
        }

    getInitialState: ->
        return {
            'val': this.props.value
        }

    clear: ->
        this.setState
            val: ''
        this.props.onChange ''

        S('suggestion', {
            list: []
        })

    delay: 0
    oninput: (e)->
        value = e.target.value
        _this = this

        this.setState
            val: value
        this.props.onChange value

        if @props.disableSuggestion
            return

        # 减少请求次数 @TODO
        clearTimeout(this.delay);
        ((value)->
            _this.delay = setTimeout ->
                A('suggestion').list {
                    'q': value.replace(/(^\s*)|(\s*$)/g, '')
                }
            , _this.props.suggestionSpeed
        )(value)
    shouldComponentUpdate: (nextProps, nextState) ->
        nextState.val != this.state.val

    render: ->
        classNames = 'icon content-clear icon-delete'

        if !this.state.val
            classNames += ' u-none'

        return (
            <span className="search-input">
                <i className="icon icon-search"></i>
                <input {...this.props} onChange={this.oninput} value={this.state.val} defaultValue={this.props.value} ref="input" type="text" />
                <i ref="clear" onClick={this.clear} onTouchStart={this.clear} className={classNames}></i>
            </span>
        )


module.exports = Search
