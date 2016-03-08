var backButton = React.createClass({
    tap: function(){
        if (sipinConfig.env === "production"){
            liteFlux.event.emit('click99',"click", "btn_home");
        }
        SP.redirect('/');
    },
    render: function(){
        var classes = SP.classSet("navbar-icon",this.props.className);
        return (
            <Button {...this.props} onTap={this.props.Tap || this.tap} className={classes} bsStyle="icon" icon="home" ></Button>
        );
    }
});

module.exports = backButton;
