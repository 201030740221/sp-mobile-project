var backButton = React.createClass({
    tap: function(){
        if(window.pageHistory.stack.length==1){
            SP.redirect( this.props.backPage || '/', true);
        }else{
            SP.back();
        }
    },
    render: function(){
        var classes = SP.classSet("navbar-icon",this.props.className);
        return (
            <Button {...this.props} onTap={this.props.onTap || this.tap} className={classes} bsStyle="icon" icon="back" ></Button>
        );
    }
});

module.exports = backButton;
