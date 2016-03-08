###
# Cart-empty
# @author remiel.
# @page Cart
###

T = React.PropTypes

CartEmpty = React.createClass
    goToHome: () ->
        if sipinConfig.env == "production"
            liteFlux.event.emit('click99',"click", "btn_home");
        SP.redirect '/'

    render: ->
        # <div className="cart-empty u-text-center">
        #     <div className="u-f14 u-mb-5">您的购物车内暂时没有商品</div>
        #     <div className="u-f12 u-color-gray-summary">您可以回首页挑选喜欢的商品</div>
        #
        # </div>
        btn = <Button bsStyle='primary' large className="u-mt-10" onTap={@goToHome}>返回首页</Button>
        texts = [
            "您的购物车内暂时没有商品"
            "您可以回首页挑选喜欢的商品"
        ]

        <Empty btn={btn} texts={texts}/>

module.exports = CartEmpty
