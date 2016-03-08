###
# 商品单顶
# @author  wilson.
# @module GoodsItem
###
Store = require('stores/good-detail');
GoodsItem = React.createClass
    getDefaultProps: ->
        {
            type: "favorite"
        }
    onRemoveFavorite: (id,index)->
        liteFlux.action("member-favorite").removeFavorite(id,index)

    onAddToCart: (id)->
        # 99click 加入购物车按钮统计
        if sipinConfig.env == "production"
            liteFlux.event.emit('click99',"click", "btn_add_to_cart");
        liteFlux.action("cart").addToCart id

    renderGoodListActionBar: ->
        return (
            <div className="good-item-actions u-text-center">
                <AddToCart><Tappable onTap={this.onAddToCart.bind(null,@props.data.sku_id)} bsStyle="link">加入购物车</Tappable></AddToCart>
            </div>
        )
    renderFavoriteActionBar: ->
        return (
            <div className="good-item-actions u-text-center">
                <AddToCart><Tappable onTap={this.onAddToCart.bind(null,@props.data.sku_id)} bsStyle="link"  name="tocart">加入购物车</Tappable></AddToCart>
                <span className="action-border">|</span>
                <Button onTap={this.onRemoveFavorite.bind(null,@props.data.id,@props.index)} bsStyle="link">删除</Button>
            </div>
        )
    renderItemAction: ->
        switch @props.type
            when "favorite"
                @renderFavoriteActionBar()
            when "goodlist"
                @renderGoodListActionBar()
    render: ->
        # console.log @props
        clearState = =>
            liteFlux.store("detail").reset();
        return (
            <div className="good-item">
                <div className="good-item-inner">
                    <div className="good-item-image u-text-center">
                        <Link beforeAction={clearState} href={"/item/" + @props.data.sku_sn}>
                            <Img src={@props.data.img} w={320} />
                        </Link>
                    </div>
                    <div className="good-item-title u-text-center">
                        <h3><Link beforeAction={clearState} href={"/item/" + @props.data.sku_sn}>{@props.data.title}</Link></h3>
                        <div className="price">
                            ￥{@props.data.price}
                        </div>
                    </div>
                    {@renderItemAction()}
                </div>
            </div>
        )


module.exports = GoodsItem
