var liteFlux = require('lite-flux');

var store = liteFlux.store("memberLogin",{
    data: {
        account: '',
        accountLength: 4,
        accountError: '',
        password: '',
        passwordLength: 6,
        passwordError: '',
        remember: true,
        submitText: "登录",
        modalShow: false
    },
    actions:{
        validatorData: function(){
            return liteFlux.validator(store,{
                'account':{
                    required: true,
                    minLength: 4,
                    maxLength: 32,
                    message: {
                        required: "用户名不能为空",
                        minLength: "最小长度不能小于4位",
                        maxLength: "最大长度不能大于20位"
                    }
                },
                'password':{
                    required: true,
                    minLength: 6,
                    maxLength: 36,
                    password: true,
                    message: {
                        required: "密码不能为空",
                        minLength: "最小长度不能小于4位",
                        maxLength: "最大长度不能大于20位",
                        password: "格式错误，请输入正确的密码"
                    }
                }
            },{
                //oneError: true
            });
        }
    }
});




module.exports = store;
