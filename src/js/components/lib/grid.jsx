/**
 * Grid，网格布局容器
 * <Grid>
 *    <Col>
 *    <Col>
 * </Grid>
 * 属性 avg，表示是等分网格， 最大支持12等分
 * 属性 cols，当前可选值 5|24，表示使用5列网格还是24列
 * @tofishes
 * @type {[type]}
 */
var React = require('react')
,   Col = require('./col')
,   utilMixin = require('./mixins/util-mixin');

var Grid = React.createClass({
    mixins: [utilMixin],
    propTypes: {
        'avg': React.PropTypes.number,
        'cols': React.PropTypes.number
    },
    getDefaultProps: function () {
        return {
            'avg': 1,
            'cols': 24
        };
    },

    render: function() {
        var classes = 'grid',
        avg = this.props.avg;

        if (avg > 1) {
            classes += ' grid-' + avg;
        }

        classes = SP.classSet(classes,this.props.className);

        var children = this.propsToChildren(Col, {
            'cols': this.props.cols,
            'avg': avg
        });

        return (
            <div className={classes}>
                {children}
            </div>
        );
    }

});

module.exports = Grid;
