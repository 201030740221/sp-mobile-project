module.exports = {
    cart: function(text) {
        var Cart = require('pages/cart/cart/cart');
        return (
            <View>
                <Cart></Cart>
            </View>
        );
    },
    checkout: function(text) {
        var Checkout = require('pages/cart/checkout/checkout');
        return (
            <View>
                <Checkout></Checkout>
            </View>
        );
    },
    checkoutAddress: function(){
        var Address = require('pages/member/address/address');
        return (
            <View>
                <Address type="checkout"></Address>
            </View>
        );
    },
    checkoutNewAddress: function(){
        var NewAddress = require('pages/member/address/new-address');
        return (
            <View>
                <NewAddress type="checkout"></NewAddress>
            </View>
        );
    },
    checkoutInvoice: function(){
        var Invoice = require('pages/member/invoice/invoice');
        return (
            <View>
                <Invoice type="checkout"></Invoice>
            </View>
        );
    },
    checkoutCoupon: function(){
        var Coupon = require('pages/member/coupon/coupon');
        return (
            <View>
                <Coupon type="checkout"></Coupon>
            </View>
        );
    },
    checkoutServiceCard: function(){
        var Page = require('pages/member/service-card/index');
        return (
            <View>
                <Page type="checkout"></Page>
            </View>
        );
    },
    exchangeCheckout: function() {
        var Checkout = require('pages/cart/checkout/exchange-checkout');
        return (
            <View>
                <Checkout></Checkout>
            </View>
        );
    },
    exchangeAddress: function(){
        var Address = require('pages/member/address/address');
        return (
            <View>
                <Address type="exchange"></Address>
            </View>
        );
    },
    exchangeNewAddress: function(){
        var NewAddress = require('pages/member/address/new-address');
        return (
            <View>
                <NewAddress type="exchange"></NewAddress>
            </View>
        );
    }
};
