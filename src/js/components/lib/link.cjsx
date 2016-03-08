Tappable = require('react-tappable')

Link = React.createClass
    propTypes:
        href: React.PropTypes.string
    getDefaultProps: ->
        bsStyle: 'default'
    onTap: ->
        if @props.beforeAction
            @props.beforeAction()
        if @props.href
            if /^http/.test @props.href
                if @props.target == "_blank"
                    window.open @props.href
                else
                    window.location.href = @props.href
            else
                SP.redirect @props.href
    render: ->
        classMap =
            'link': true

        classes = SP.classSet(classMap,this.props.className)
        delete this.props.className

        <Tappable {...this.props} ref='link' role='link' className={classes} onTap={this.props.onTap || this.onTap} >
            {this.props.children}
        </Tappable>

module.exports = Link;
