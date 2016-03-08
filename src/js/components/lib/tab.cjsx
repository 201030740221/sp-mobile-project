###
# Tab.
# @author remiel.
# @module Tab
###
T = React.PropTypes

Tab = React.createClass

    render: ->
        className = SP.classSet 'tab u-flex-box',
            'underline': @props.underline
        <div className={className}>
            {@props.children}
        </div>

TabItem = React.createClass

    propsType:
        href: T.string

    getDefaultProps: ->
        href: null

    onTap: () ->

    render: ->
        classes = SP.classSet 'tab-item', 'u-flex-item-1', @props.className
        if @props.href
            <Link {...@props} href={@props.href} className={classes}>
                <span className="tab-item-inner">{@props.children}</span>
            </Link>
        else
            <Tappable {...@props} className={classes} onTap={@props.onTap || @onTap} >
                <span className="tab-item-inner">{@props.children}</span>
            </Tappable>


module.exports =
    Tab: Tab
    TabItem: TabItem
