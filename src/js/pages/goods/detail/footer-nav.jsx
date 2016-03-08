/**
 * fix footer nav
 */
// var count = 1;
var Store = require('stores/good-detail');
var Action = Store.getAction();
var GoodFooterNav = React.createClass({
    mixins:[liteFlux.mixins.storeMixin('detail')],
    jumpToCart: function(){
        if (sipinConfig.env === "production"){
            liteFlux.event.emit('click99',"click", "cart");
        }
        SP.redirect('/cart');
    },
    addToCart: function(e){
        e.stopPropagation();
        if(!this.isDisabled()){
            if (sipinConfig.env === "production"){
                liteFlux.event.emit('click99',"click", "btn_add_to_cart");
            }
            var goods_sku_id = this.props.g_id , goods_sku_quantity = S('detail').quantity;
            liteFlux.action("cart").addToCart(goods_sku_id , goods_sku_quantity);
        }else{
            SP.message({
                msg: "请先选择商品规格"
            });
        }
    },
    buyRightNow: function(){
        // var data = {
        //     'item': this.props.g_id,
        //     'quantity':  S('detail').quantity,
        //     'region_id': S('region').district
        // };

        if(!this.isDisabled()){
            if (sipinConfig.env === "production"){
                liteFlux.event.emit('click99',"click", "btn_buy_now");
            }
            A("checkout").quickbuy(this.props.g_id, S('detail').quantity, S('region').district);
        }else{
            SP.message({
                msg: "请先选择商品规格"
            });
        }
    },
    // 判断是否有属性没有选中
    isDisabled: function(){
        var self = this;
        var disabled = false;
        Object.keys(this.state.detail.attribute_key).map(function(item){
            if(!self.state.detail.attribute_key[item])
                disabled = true;
        });

        return disabled;
    },
    loadMeiQia: function(){
        if (sipinConfig.env === "production"){
            liteFlux.event.emit('click99',"click", "btn_customer_service");
        }
        if(typeof mechatClick != 'undefined'){
            mechatClick();
        }
    },
    render: function() {

        return (
            <Grid cols={24}>
                <Col span={8} className="nav-btn-panel">
                    <AddToCart block disabled={this.isDisabled()} component={Button} className="nav-btn put-in-cart" onTap={this.addToCart} name="tocart">加入购物车</AddToCart>
                </Col>
                <Col span={8} className="nav-btn-panel">
                    <Button bsStyle="primary" block disabled={this.isDisabled()} onTap={this.buyRightNow} name="buy">立即购买</Button>
                </Col>
                <Col span={4} className="nav-btn-panel">
                    <Tappable className='nav-btn-smallbtn' onTap={this.loadMeiQia}>
                        <div className="nav-btn-smallbtn-icon"><Icon name="service" /></div>
                        <div className="nav-btn-smallbtn-text">客服</div>
                    </Tappable>
                </Col>
                <Col span={4} className="nav-btn-panel">
                    <Tappable className='nav-btn-smallbtn' onTap={this.jumpToCart}>
                        <LiteCart />
                        <div className="nav-btn-smallbtn-icon"><Icon name="cart" /></div>
                        <div className="nav-btn-smallbtn-text">购物车</div>
                    </Tappable>
                </Col>
            </Grid>
        )
    }
});


module.exports = GoodFooterNav;
