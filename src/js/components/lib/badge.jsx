var React = require('react');
var Badge = React.createClass({
    render: function(){
        return (
            <div {...this.props.props} className={this.props.className}>
                <span className="badge bg-darkred">{this.props.children}</span>
            </div>
        );

    }
});

module.exports = Badge;
