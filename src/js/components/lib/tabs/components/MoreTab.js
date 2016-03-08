var React = require('react');
var Tab = require('./Tab');

module.exports = React.createClass({
  displayName: 'MoreTab',

  propTypes: {
    maxCount: React.PropTypes.number
  },

  getDefaultProps: function () {
    return {
      maxCount: 0
    };
  },

  render: function () {
    return (
      <Tab visible={this.props.moreCount > 0}
          {...this.props}
      >
        <div>{this.props.moreCount} More &#9660;</div>
      </Tab>
    );
  }
});
