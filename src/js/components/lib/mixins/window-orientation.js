var React = require('react'),
Events = require('utils/events'),
Dom = require('utils/dom');
module.exports = {
    componentDidMount: function() {
        this._onorientationchange();
        Events.on(window, "onorientationchange" in window ? "orientationchange" : "resize", this._onorientationchange);
    },
    componentWillUnmount: function() {
        Events.off(window, "onorientationchange" in window ? "orientationchange" : "resize", this._onorientationchange);
    },
    _onorientationchange: function(){
        var body = document.body;
        if(window.orientation === 180 || window.orientation === 0){
            // alert("竖屏状态！");
            Dom.addClass(body, 'vertical');
            Dom.removeClass(body, 'horizontal');
        }
        if(window.orientation === 90 || window.orientation === -90){
            // alert("横屏状态！");
            Dom.addClass(body, 'horizontal');
            Dom.removeClass(body, 'vertical');
        }
        //PC端木有orientation
        if(window.orientation === undefined){
            if(window.innerHeight < window.innerWidth){
                Dom.addClass(body, 'horizontal');
                Dom.removeClass(body, 'vertical');
            }else{
                Dom.addClass(body, 'vertical');
                Dom.removeClass(body, 'horizontal');
            }
        }
    }
}
