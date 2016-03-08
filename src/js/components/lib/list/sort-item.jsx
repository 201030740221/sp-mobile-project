/**
 * 排序组件
 * 提供升序降序的状态反馈
 * @tofishes
 */
var React = require('react');

var SortItem = React.createClass({
    propTypes: {
        // 'asc': React.PropTypes.bool,
        'desc': React.PropTypes.bool,
        'onChange': React.PropTypes.func,
        'name': React.PropTypes.string
    },
    getDefaultProps: function () {
        return {
            // asc: true,
            name: null,
            desc: false,
            onChange: function(){}
        }
    },
    getInitialState: function () {
        return {
            'desc': this.props.desc
        }
    },
    onClick: function () {
        var status = !this.state.desc
        this.setState({
            'desc': status
        })
        this.props.onChange.call(this, this.props.name, status ? 'desc' : 'asc')
    },
    render: function() {
        var classes = "sort-item";

        if (this.state.desc) {
            classes += ' sort-desc';
        }

        return (
            <Tappable onTap={this.onClick} component="span" className={classes}>{this.props.children}<i className="icon"/></Tappable>
        );
    }

});

module.exports = SortItem;