###
# Loading.
# @author remiel.
# @module Loading
###
T = React.PropTypes

Loading = React.createClass
    render: ->
        className = SP.classSet "loading icon icon-loadinglogo",
            "inside": @props.inside
        <div className={className} />

module.exports = Loading
