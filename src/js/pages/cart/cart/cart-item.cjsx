###
# Cart-item.
# @author remiel.
# @page Cart
###
Store = appStores.cart
Action = Store.getAction()
storeName = 'cart'

T = React.PropTypes

CartItem = React.createClass

    onSelected: (checked) ->
        Action.select @props.data.id, checked

    onCounterCallback: (value) ->
        Store.getAction().updateSku @props.data.id, value

    render: ->
        data = @props.data
        item = @props.item
        checked = @props.checked
        pointNode = ''
        point = 0
        price = item.price
        # price = item.price.toFixed 2
        # if @props.type is 1
        #     total_point = data.total_point
        #     pointNode = <h5 className="u-ellipsis u-color-blackred">
        #         <span className="u-color-blackred">（积分兑换，消耗{total_point}积分）</span>
        #     </h5>
        #     price = "0.00"
        soldOut = <div className="cart-item-sold-out">已下架</div> if item.on_sale is 0

        <div className='cart-item'>
            <Checkbox checked={checked} onChange={@onSelected}></Checkbox>
            <div className="img">
                <Img src={item.image} w={100} />
                {soldOut}
            </div>
            <div className="cart-item-contnet">
                <h4>
                    <span className="u-ellipsis">{item.title}</span>
                    <span className="cart-item-price">￥{price}</span>
                </h4>
                {pointNode}
                <h5 className="u-ellipsis">{item.sub_title}</h5>
                <Counter delay={500} callback={@onCounterCallback} current={+item.quantity}></Counter>
            </div>
        </div>

module.exports = CartItem
