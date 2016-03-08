var React = require('react');

var View = React.createClass({

    render: function() {
        var classMap = {
            'content-block': true
        };

        var classes = SP.classSet(classMap,this.props.className);
        
        return (
            <div {...this.props} className={classes}>
                <div className="content-block-inner">
                    {this.props.children}
                </div>
            </div>
        );
    }

});

module.exports = View;
