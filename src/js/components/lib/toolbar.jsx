var React = require('react');
var sp = require('SP');

var Toolbar = React.createClass({
    propTypes: {
        flexbox: React.PropTypes.bool
    },
    getDefaultProps: function() {
        return {
            flexbox: false
        };
    },
    render: function() {

        var classMap = {
            'toolbar': true,
            'bar-flexbox': this.props.flexbox
        };

        var classes = SP.classSet(classMap,this.props.className);

        return (
            <div {...this.props} className={classes}>
                <div className="toolbar-inner">
                    {this.props.children}
                </div>
            </div>
        );
    }

});

module.exports = Toolbar;
