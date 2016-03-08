var T = React.PropTypes;

var ListItem = React.createClass({
    propTypes: {
        icon: T.string,
        // title: T.string,
        tips: T.string,
        value: T.string
    },
    renderMedia: function(){
        if(this.props.icon){
            if(typeof this.props.icon === "function"){
                return (
                    <div className="item-media">{this.props.icon()}</div>
                );
            }else{

                var classMap = {};
                classMap.icon = true;
                classMap['icon-'+this.props.icon.trim()] = true;

                var classes = SP.classSet(classMap);

                return (
                    <div className="item-media"><i className={classes}></i></div>
                );
            }

        }
    },
    renderTitle: function(){
        if(this.props.title){
            return (
                <div className="item-title label">
                    {this.props.title}
                </div>
            );
        }
    },
    renderItemTips: function(){

        var self = this;

        var tips = function(){
            if(self.props.tips){
                return (
                    <span>{self.props.tips}</span>
                );
            }
        };

        var noread = function(){
            if(self.props.noread && parseInt(self.props.noread) > 0){
                return (
                    <Badge>{self.props.noread}</Badge>
                );
            }
        };

        return (
            <div className="item-after">
                {tips()}
                {noread()}
            </div>
        );
    },
    renderItemAfter: function(){
        if(this.props.value){
            return (
                <div className="item-input">
                    {this.props.value}
                </div>
            );
        }
    },
    renderContent: function(){
        return (
            <div className="item-content">
                {this.renderMedia()}
                <div className="item-inner">
                    {this.renderTitle()}
                    {this.renderItemAfter()}
                    {this.renderItemTips()}
                </div>
            </div>
        );
    },
    onTap: function(e){
        e.preventDefault();
        e.stopPropagation();

        if(this.props.beforeAction){
            this.props.beforeAction();
        }

        if(this.props.onTap){
            this.props.onTap();
        }else{
            if(this.props.href){
                SP.redirect(this.props.href);
            }
        }

    },
    renderWrap: function(){
        if( this.props.arrow || this.props.href ){
            return (
                <Tappable onTap={this.onTap} className="item-link">
                    {this.renderContent()}
                </Tappable>
            );
        }else{
            if(this.props.hasTap){
                return (
                    <Tappable onTap={this.onTap}>
                        {this.renderContent()}
                    </Tappable>
                );
            }else{
                return this.renderContent();
            }
        }
    },
    render: function() {
        return (
            <li {...this.props}>
                {this.renderWrap()}
            </li>
        );
    }

});

module.exports = ListItem;
