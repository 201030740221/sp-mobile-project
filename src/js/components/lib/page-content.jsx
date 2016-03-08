/**
 * 一个视图窗口，用于 Body > View，当有多个可切换页面的情况时候使用
 * onPushRefresh: 下拉刷新
 * onPullRefresh: 上拉刷新 @TODO
 * @type {[type]}
 */
var React = require('react');
var View = React.createClass({

    render: function() {

        var classMap = {
            'page-content': true
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
