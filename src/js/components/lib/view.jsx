/**
 * 一个视图窗口，用于 Body > View，当有多个可切换页面的情况时候使用
 * @type {[type]}
 */
var React = require('react');
var Pages = require('./pages');
//var EnterAnimation = require('enter-animation');

var View = React.createClass({
    getInitialState: function () {
        return {
            enter: {
                delay: 0.3,
                type: "alpha"
            },
            leave: {
                delay: 0.2,
                type: "alpha"
            }
        };
    },
    render: function() {

        var classMap = {
            'view': true
        };

        var classes = SP.classSet(classMap,this.props.className);

        var wrapper = (
            <div {...this.props} className={classes}>
                <Pages>
                    {this.props.children}
                </Pages>
            </div>
        );

        var key = window.location.hash;

        return wrapper;

        // return (
        //     <EnterAnimation className='animation-wrap' enter={this.state.enter} leave={this.state.leave}>
        //         {React.cloneElement(wrapper, {key: key})}
        //     </EnterAnimation>
        // );
    }

});

module.exports = View;
