/**
 * MenuListView, 列表菜单框架
 * @type {[type]}
 */
var React = require('react');
var ListItem = require('./list-item');

var ListView = React.createClass({
    getTitle: function(){
        if(this.props.title){
            return (
                <div className="list-block-title">
                    {this.props.title}
                    <div className="list-block-title-right-icon">
                        {this.props.titleRightIcon}
                    </div>
                </div>
            );
        }
    },
    render: function() {
        var classMap = {
            "list-block": true,
            "menu-list-view": true,
            "list-block-has-title": this.props.title,
            "list-block-label-gray": this.props['label-gray']
        };

        var classes = SP.classSet(classMap,this.props.className);

        return (
            <div className={classes}>
                {this.getTitle()}
                <div className="list-block-inner">
                    <ul>
                        {this.props.children}
                    </ul>
                </div>
            </div>
        );
    }

});

ListView.Item = ListItem;



module.exports = ListView;
