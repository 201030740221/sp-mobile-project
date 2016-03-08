CompleteView = React.createClass

    renderButtons: ->
        @props.data.button.map (item, i)->
            jumpUrl = ->
                if typeof item.url == "function"
                    item.url()
                else
                    SP.redirect item.url,true

            bsStyle = item.bsStyle || "primary"
            outlined = item.outlined || false
            <div className="u-mb-20" key={i}>
                <Button onTap={jumpUrl} outlined={outlined} bsStyle={bsStyle}>{item.text}</Button>
            </div>
    render: ->
        classMap = {
            "icon": true
            "icon-error": @props.fail
            "icon-select": !@props.fail
        }

        classes = SP.classSet classMap

        <div className="empty complete-panel">
            <div className={classes}></div>
            <div className="u-f24 u-mb-5">{@props.data.title}</div>
            <div className="u-f12 u-mb-40 u-color-gray-summary">{@props.data.text}</div>

            {@renderButtons()}
        </div>

module.exports = CompleteView
