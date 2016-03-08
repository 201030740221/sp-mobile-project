
Filter = React.createClass
    render: ->
        classes = SP.classSet('filter',this.props.className);
        return (
            <ul {...this.props} className={classes}>
                {this.props.children}
            </ul>
        );


FilterItem = React.createClass
    render:->
        return (
            <li {...this.props}>
                {this.props.children}
            </li>
        );

module.exports = Filter
