###
# Collocation-item.
# @author remiel.
# @page Cart
###
Store = appStores.cart
Action = Store.getAction()

T = React.PropTypes

CartItem = React.createClass

    getInitialState: ->
        openGoodsView: no

    toggleopenGoodsView: () ->
        state = @state.openGoodsView
        @setState
            openGoodsView: !state

    onSelected: (checked) ->
        Action.select @props.data.id, checked

    onCounterCallback: (value) ->
        Store.getAction().updateSku @props.data.id, value

    renderItem: (item, i) ->
        soldOut = <div className="cart-item-sold-out">已下架</div> if item.on_sale is 0

        <div className='cart-item' key={i}>
            <div className="img">
                <Img src={item.image} w={100} />
                {soldOut}
            </div>
            <div className="cart-item-contnet">
                <h4>
                    <span className="u-ellipsis">{item.title}</span>
                    <span className="cart-item-price">￥{item.price}</span>
                </h4>
                <h5 className="u-ellipsis">{item.sub_title}</h5>
                <h5 className="u-ellipsis">x{item.quantity}</h5>
            </div>
        </div>
    renderList: () ->

        data = @props.data
        items = data.items
        items.map (item, i) =>
            @renderItem item, i




    renderFooter: () ->
        data = @props.data
        if data.items.length and (data.items.length > 1)
            <Tappable component="footer" className={'active' if @state.openGoodsView} onTap={@toggleopenGoodsView}>
                <Button bsStyle="icon" icon="arrowdownlarge" />
            </Tappable>
        else
            ""
    render: ->
        data = @props.data
        price = data.price
        checked = @props.checked

        <div className='cart-collocation'>
            <div className="u-pr u-f14">
                <Checkbox checked={checked} onChange={@onSelected}></Checkbox>
                <div className="cart-collocation-title">
                    {data.name}
                    （共
                    <span className="u-color-blackred">{data.total_quantity}</span>
                    件商品）
                </div>
            </div>
            <div className="cart-collocation-content">
                <span className="cart-collocation-price">￥{price}</span>
                <Counter delay={500} callback={@onCounterCallback} current={+data.quantity}></Counter>
            </div>
            <div className={'active' if @state.openGoodsView}>
                {@renderList()}
            </div>
            {@renderFooter()}
        </div>

module.exports = CartItem
