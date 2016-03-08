/**
 * 一个视图窗口，用于 Body > View，当有多个可切换页面的情况时候使用
 * @type {[type]}
 */
var React = require('react');

var View = React.createClass({

    render: function() {

        var classMap = {
            'page': true,
            'navbar-through': typeof this.props['navbar-through'] != "undefined",
            'toolbar-through': typeof this.props['toolbar-through'] != "undefined"
        };

        var classes = SP.classSet(classMap,this.props.className);
        
        return (
            <div {...this.props} className={classes}>
                {this.props.children}
            </div>
        );
    }

});

module.exports = View;
