var windowOrientation = require('./mixins/window-orientation');
var Container = React.createClass({
    mixins:[windowOrientation],
    render: function() {
        var classMap = {
            'views': true
        };

        var classes = SP.classSet(classMap,this.props.className);

        return (
            <div id="container" {...this.props} className={classes}>
                {this.props.children}
            </div>
        );
    }

});

module.exports = Container;
