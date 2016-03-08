/**
 * 一个视图窗口，用于 Body > View，当有多个可切换页面的情况时候使用
 * onPushRefresh: 下拉刷新
 * onPullRefresh: 上拉刷新 @TODO
 * @type {[type]}
 */
var React = require('react')
,   Events = require('utils/events');

var View = React.createClass({
    propTypes: {
        'onPushRefresh': React.PropTypes.func,
        'canRefresh': React.PropTypes.func
    },
    getDefaultProps: function () {
        return {
            'onPushRefresh': null,
            'canRefresh': function () {return false}
        }
    },
    getInitialState: function () {
        return {
            'loaded': false
        }
    },
    loaded: function (isLoaded) {
        this.setState({
            'loaded': isLoaded
        });
    },

    componentDidMount: function() {
        var _this = this;
        var page = React.findDOMNode(this);

        if (this.props.onscroll) {
            Events.on(page, 'scroll', function (e) {
                _this.props.onscroll.call(page, e);
            });
        }

        /* @TODO 复杂的加载判断，或许可以优化 */
        var maxH = 100 // pushup 区域最大高度

        ,   currPosY // 触摸移动的当前位置
        ,   movePosY  // 触摸移动的实时位置，结合currPosY可以判断出是上拉还是下拉
        ,   isUping // 上拉判断
        ,   isDowning // 下拉判断

        ,   pageMovePos  // 容器底部被移动的绝对距离 = 滚动高度+自身高度
        ,   originPageH  // 触摸开始，记录当前容器原始高度，用于避免 pushup 引起的高度变化

        ,   upingStart  // 到达底部，开始上拉的起点位置记录
        ,   downingStart // 转为下拉的起点位置记录
        ,   _heigh

        ,   loaded = this.loaded;

        Events.on(page, 'touchstart', function (e) {
            if (! _this.props.canRefresh()) {
                return loaded(true);
            }
            loaded(false)

            currPosY = e.touches[0].screenY
            originPageH = page.offsetHeight
        })
        Events.on(page, 'touchmove', function (e) {

            if (! _this.props.canRefresh()) {
                return loaded(true);
            }
            loaded(false)

            var pushup = React.findDOMNode(_this.refs.pushup)

            movePosY = e.touches[0].screenY;
            isUping = currPosY > movePosY;
            isDowning = currPosY < movePosY;

            currPosY = movePosY;
            pageMovePos = page.scrollTop + originPageH

            if (isUping && pageMovePos >= page.scrollHeight) {
                upingStart = upingStart || movePosY
                downingStart = null;
                _height = Math.min(maxH, Math.abs(movePosY - upingStart))
                pushup.style.height = _height + 'px'
                if (_height == maxH) {
                    e.preventDefault()
                }
            }

            if (isDowning && pageMovePos <= page.scrollHeight) {
                upingStart = null;
                downingStart = downingStart || movePosY;

                pushup.style.height = Math.max(0,  pushup.offsetHeight - (movePosY - downingStart)) + 'px'
            }
        });
        Events.on(page, 'touchend', function (e) {
            if (! _this.props.canRefresh()) {
                return loaded(true);
            }
            loaded(false);
            var pushup = React.findDOMNode(_this.refs.pushup)

            upingStart = null;
            if (pushup.offsetHeight) {
                // 达到一定高度，松手加载，否则不加载
                pushup.offsetHeight > maxH / 1.5 && _this.props.onPushRefresh.call(page, function () {
                    // 调用方在数据加载完毕后，调用回调，隐藏加载提示
                    pushup.style.height = '0'
                });
            }
        });

    },

    render: function() {
        isPushRefresh = !!this.props.onPushRefresh

        var classMap = {
            'page-content': true,
            'push-refresh': isPushRefresh
        };

        var classes = SP.classSet(classMap,this.props.className);

        var pushLoding = '';

        var classRefresh = SP.classSet({
            'push-refresh-tip': true,
            'loaded': this.state.loaded
        });

        if (isPushRefresh) {
            pushLoding = <div className={classRefresh} ref="pushup"></div>
        }

        return (
            <div {...this.props} className={classes}>
                {this.props.children}
                {pushLoding}
            </div>
        );
    }

});

module.exports = View;
