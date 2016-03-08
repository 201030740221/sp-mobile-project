/**
 * Col，网格布局容器中的列
 * 默认为24列网格，span表示跨几列，cols表示总共几列
 * <Grid cols={24}>
 *    <Col span={7}>
 *    <Col span={5}>
 *    <Col span={9}>
 *    <Col span={3}>
 * </Grid>
 * cols可选值为： 5|24， 下面是5列网格写法
 * <Grid cols={5}>
 *    <Col span={2}>
 *    <Col span={3}>
 * </Grid>
 * @tofishes
 * @type {[type]}
 */
var React = require('react');

var Col = React.createClass({
    propTypes: {
        'span': React.PropTypes.number,
        'cols': React.PropTypes.number,
        'avg': React.PropTypes.number
    },
    getDefaultProps: function () {
        return {
            'avg': 1,
            'span': 1,
            'cols': 24
        };
    },

    render: function() {
        var span = this.props.span,
            cols = this.props.cols,
            classes = this.props.avg > 1 ? '' : 'col-' + span + '-' + cols ;

        classes = SP.classSet(classes,this.props.className);

        return (
            <div className={classes}>
                {this.props.children}
            </div>
        );
    }

});

module.exports = Col;
