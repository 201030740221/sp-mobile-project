###
# Empty
# @author remiel.
# @module Empty
###

T = React.PropTypes

Empty = React.createClass
    propTypes:
        texts: T.array
        btn: T.element

    getDefaultProps: ->
        texts: []
        btn: <span></span>

    render: ->

        content = @props.texts.map (item, i) ->
            if i is 0
                <div className="u-f14 u-mb-5" key={i}>{item}</div>
            else
                <div className="u-f12 u-color-gray-summary" key={i}>{item}</div>


        <div className="empty">
            <div className="icon icon-cartempty"></div>
            {content}
            {@props.btn}
        </div>

module.exports = Empty
