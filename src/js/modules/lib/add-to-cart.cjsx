
getProperty = (name)->
    prefixes = ['Webkit', 'Moz', 'O', 'ms', '']
    testStyle = document.createElement('div').style

    for v, i in prefixes
        return v + name if testStyle[v + name] isnt undefined

    # Not Supported
    return undefined

support =
    'touch': 'ontouchend' in document || window.DocumentTouch && document instanceof DocumentTouch
    'transform': !!(getProperty 'Transform')
    'transform3d': !!(window.WebKitCSSMatrix and 'm11' in new WebKitCSSMatrix())

u =
    support: support
    getProperty: getProperty

AddToCart = React.createClass
    onTap: (e) ->
        # 99click 购物车按钮统计
        if sipinConfig.env == "production"
            liteFlux.event.emit('click99',"click", "btn_cart");
        @props.onTap(e) if @props.onTap?
        if not document.getElementById 'j-lite-cart'
            return 0
        if @props.disabled
            return 0
        box = @refs.box.getDOMNode()
        btn = @refs.btn.getDOMNode()
        offset = @offset btn
        item = document.createElement 'div'
        box.appendChild item
        id = "j-add-cart-" + (+new Date())
        el = <i id={id} className="add-to-cart-anmite"></i>
        React.render(el, item)
        setTimeout () =>
            @change id, offset, item
        , 200
    change: (id, offset, box) ->
        el = document.getElementById id
        cart = document.getElementById 'j-lite-cart'
        winWidth = window.innerWidth
        winHeight = window.innerHeight
        cartOffset = @offset cart
        _offset = offset
        x0 = offset.left
        y0 = offset.top
        xt = cartOffset.left + cartOffset.width /2
        yt = cartOffset.top #+ cartOffset.height /2
        x = xt - x0
        y = yt - y0
        rid = null
        t0 = 0
        g = - 1.1
        vx = 4
        if _offset.left < winWidth * 5 / 6
            vx = 2
        if _offset.left < winWidth * 4 / 6
            vx = 3
        if _offset.left < winWidth * 3 / 6
            vx = 4
        if _offset.left < winWidth * 2 / 6
            vx = 7
        if _offset.left < winWidth * 1 / 6
            vx = 8

        if winWidth > winHeight and winWidth <= 640
            if _offset.left < winWidth * 7 / 8
                vx = 6
            if _offset.left < winWidth * 6 / 8
                vx = 6
            if _offset.left < winWidth * 5 / 8
                vx = 10
            if _offset.left < winWidth * 4 / 8
                vx = 11
            if _offset.left < winWidth * 3 / 8
                vx = 12
            if _offset.left < winWidth * 2 / 8
                vx = 13
            if _offset.left < winWidth * 1 / 8
                vx = 14

        t = x/vx
        v0 = - Math.sqrt(vx*vx + (y+1/2*g*t*t)/t * (y+1/2*g*t*t)/t)
        a = Math.acos(x/t/v0)

        go = () =>
            t0++
            _offset =
                left: vx * t0
                top: (v0 * Math.sin(a)* t0 - 1/2*g*t0*t0)
            el.style['left'] = _offset.left + 'px' if t0 < t
            el.style['top'] = _offset.top + 'px'
            if t0 > t
                if _offset.top > y
                    cancelAnimationFrame(rid)
                    @remove box
                else
                    rid = requestAnimationFrame(go)
            else
                rid = requestAnimationFrame(go)

        requestAnimationFrame(go)

    remove: (box) ->
        React.unmountComponentAtNode(box)

    offset: (el)->
        rect = el.getBoundingClientRect();
        top: rect.top + document.body.scrollTop,
        left: rect.left + document.body.scrollLeft
        height: rect.height
        width: rect.width

    render: ->
        classes = SP.classSet "add-to-cart", @props.className
        <Tappable {...@props} className={classes} onTap={@onTap}>
            <div ref="box" className="add-to-cart-inner"><span ref="btn"></span></div>
            {@props.children}
        </Tappable>
module.exports = AddToCart
