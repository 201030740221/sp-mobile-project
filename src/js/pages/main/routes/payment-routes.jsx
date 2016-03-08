module.exports = {
    payment: function(id){
        var Payment = require('pages/payment/payment/payment');
        return (
            <View>
                <Payment id={id}></Payment>
            </View>
        );
    },
    paymentComplete: function(id,no){
        var PaymentComplete = require('pages/payment/complete/complete');
        return (
            <View>
                <PaymentComplete id={id} no={no}></PaymentComplete>
            </View>
        );
    },
};
