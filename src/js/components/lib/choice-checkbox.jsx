var ChoiceCheckbox = React.createClass({
    render: function() {
        return (
            <ul className="choice-checkbox-list">
                {this.props.children}
            </ul>
        );
    }

});

var ChoiceCheckItem = React.createClass({
    render: function(){
        var classes;

        var classMap = {
            "active": this.props.status,
            "choice-disabled": this.props.disabled
        };

        classes = SP.classSet(classMap);

        return (
            <li {...this.props} className={classes}>
                {this.props.children}
            </li>
        );
    }

});

ChoiceCheckbox.Item = ChoiceCheckItem;

module.exports = ChoiceCheckbox;
