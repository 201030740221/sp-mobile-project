var Navbar = React.createClass({
    propTypes: {
        flexbox: React.PropTypes.bool
    },
    getDefaultProps: function() {
        return {
            flexbox: true
        };
    },
    render: function() {

        var classMap = {
            'navbar': true,
            'navbar-bg': !this.props.transparent,
            'bar-flexbox': this.props.flexbox
        };

        var classes = SP.classSet(classMap,this.props.className);

        return (
            <div {...this.props} className={classes}>
                <div className="navbar-inner">
                    <div className="navbar-left">
                        {this.props.leftNavbar}
                    </div>
                    <div className="navbar-center">
                        {this.props.title || this.props.children}
                    </div>
                    <div className="navbar-right">
                        {this.props.rightNavbar}
                    </div>
                </div>
            </div>
        );
    }

});

module.exports = Navbar;
