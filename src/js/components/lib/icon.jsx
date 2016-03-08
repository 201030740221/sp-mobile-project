/**
 * Button, 按钮
 * @tofishes
 * @type {[type]}
 */
var Tappable = require('react-tappable');

var Button = React.createClass({
    propTypes: {
        active: React.PropTypes.bool,
        disabled: React.PropTypes.bool,
        size: React.PropTypes.number
    },
    getDefaultProps: function() {
        return {
        };
    },
    render: function() {
        var classMap = {
            'icon': true,
            'active': this.props.active,
            'disabled': this.props.disabled
        };

        classMap['icon-'+this.props.name.trim()] = true;


        var classes = SP.classSet(classMap,this.props.className);
        var style = {
            fontSize: this.props.size || 18,
            display: "inline-block",
            color: this.props.color
        };

        return (
            <Tappable {...this.props} style={style} ref='icon' role='icon' className={classes} >
                {this.props.children}
            </Tappable>
        );
    }

});

module.exports = Button;
