liteFlux = require('lite-flux')

store = liteFlux.store "member-password",
    data:
        oldpassword: ''
        password: ''
        repassword: ''
    actions:
        validatorData: ->
            validatorData =  liteFlux.validator this,
                'oldpassword':{
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
                },
                'repassword':{
                    required: true,
                    minLength: 6,
                    maxLength: 36,
                    password: true,
                    equal: this.getStore().password
                    message: {
                        required: "密码不能为空",
                        minLength: "最小长度不能小于4位",
                        maxLength: "最大长度不能大于20位",
                        password: "格式错误，请输入正确的密码",
                        equal: "两次输入密码不一致"
                    }
                }
            ,{}

            # 自定义校验规则，在valid调用之前定义
            validatorData.rule 'length', (val,length)->
                return val.length == length;


            validatorData
