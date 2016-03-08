###
# Tab.
# @author remiel.
# @module Tab
###
T = React.PropTypes

Tab = React.createClass

    render: ->
        className = SP.classSet 'tab',
            'underline': @props.underline
        <table className={className}>
            <tr>
                {@props.children}
            </tr>
        </table>

TabItem = React.createClass

    propsType:
        href: T.string

    getDefaultProps: ->
        href: null

    onTap: () ->

    render: ->
        classes = SP.classSet 'tab-item u-text-center', @props.className
        <Tappable component="td" {...@props} className={classes} onTap={@props.onTap || @onTap} >
            <span className="tab-item-inner">{@props.children}</span>
        </Tappable>


module.exports =
    Tab: Tab
    TabItem: TabItem
