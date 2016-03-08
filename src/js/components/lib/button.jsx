/**
 * Button, 按钮
 * @tofishes
 * @type {[type]}
 */
var Tappable = require('react-tappable');

var Button = React.createClass({
    propTypes: {
        small: React.PropTypes.bool,
        smaller: React.PropTypes.bool,
        smallest: React.PropTypes.bool,
        large: React.PropTypes.bool,
        danger: React.PropTypes.bool,
        block: React.PropTypes.bool,
        type: React.PropTypes.string,
        active: React.PropTypes.bool,
        inverse: React.PropTypes.bool,
        rounded: React.PropTypes.bool,
        outlined: React.PropTypes.bool,
        disabled: React.PropTypes.bool,
        bsStyle: React.PropTypes.string,
        onlyOnHover: React.PropTypes.bool,
        retainBackground: React.PropTypes.bool
    },
    getDefaultProps: function() {
        return {
            type: 'button',
            inverse: false,
            outlined: false,
            bsStyle: 'default',
            componentClass: React.DOM.button
        };
    },
    render: function() {
        var classMap = {
            'btn': true,
            'btn-small': this.props.small,
            'btn-smaller': this.props.smaller,
            'btn-smallest': this.props.smallest,
            'btn-danger': this.props.danger,
            'btn-large': this.props.large,
            'active': this.props.active,
            'disabled': this.props.disabled,
            'btn-block': this.props.block,
            'btn-inverse': (this.props.retainBackground ? true : false) || this.props.inverse,
            'btn-rounded': this.props.rounded,
            'btn-outlined': (this.props.inverse ? true : false) || (this.props.onlyOnHover ? true : false) || (this.props.retainBackground ? true : false) || this.props.outlined,
            'btn-onlyOnHover': this.props.onlyOnHover,
            'btn-retainBg': this.props.retainBackground,
            'btn-checkout': this.props.checkoutBtn
        };

        var classes = null;

        var bsStyles=this.props.bsStyle.split(',');
        for(var i=0; i < bsStyles.length; i++) {
            classMap['btn-'+bsStyles[i].trim()] = true;
        }

        if(typeof this.props.icon!="undefined"){
            classMap.icon = true;
            classMap['icon-'+this.props.icon.trim()] = true;
        }


        classes = SP.classSet(classMap,this.props.className);

        return (
            <Tappable {...this.props} ref='button' role='button' className={classes} >
                {this.props.children}
            </Tappable>
        );
    }

});

module.exports = Button;
