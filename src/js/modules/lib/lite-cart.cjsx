###
# LiteCart
# @author remiel.
# @module LiteCart
###

LiteCart = React.createClass
    mixins: [liteFlux.mixins.storeMixin('member')]
    goToCart: (e) ->
        if sipinConfig.env == "production"
            liteFlux.event.emit('click99',"click", "btn_my_cart");
        e.stopPropagation()
        e.preventDefault()
        SP.redirect '/cart'

    componentWillUpdate: (nextProps, nextState) ->
        quantityNode = @refs.quantity
        if @total_quantity != nextState.member.total_quantity and quantityNode
            quantityNode.getDOMNode().className = ' '
            clearTimeout @timer
            @timer = setTimeout () ->
                quantityNode.getDOMNode().className = 'animate'
            , 100

    render: ->
        @total_quantity = @state.member.total_quantity

        countLabel = ''
        classes = SP.classSet({
            'u-none': !@total_quantity
        })

        if @total_quantity
            countLabel = <span ref="quantity" className={classes}>{@total_quantity}</span>


        <Tappable onTap={@goToCart} className="lite-cart" id="j-lite-cart">
            {countLabel}
        </Tappable>

module.exports = LiteCart
