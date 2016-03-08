liteFlux = require('lite-flux')

store = liteFlux.store "member-mobile",
    data:
        account: '',
        accountError: '',
        code: '',
        pictureCode: '',
        pictureCodeError: '',
        email: '',
        emailError: '',
        codeBtnText: '获取验证码',
        submitText: '下一步',
        codeError: '',
        timeFn: null,
        time: 120,
        showHandle: false # 找回密码选择框
        forgotSwitchText: '通过手机找回密码'
    actions:
        validatorData: ->
            validatorData =  liteFlux.validator this,
                'account':{
                    required: true,
                    length: 11,
                    phone: true,
                    message: {
                        required: "请输入正确的手机号",
                        length: "请输入正确的手机号",
                        phone: "请输入正确的手机号"
                    }
                },
                'code':{
                    required: true,
                    length: 6,
                    message: {
                        required: "请输入正确的验证码",
                        length: "请输入正确的验证码"
                    }
                },
                'pictureCode':{
                    required: true,
                    length: 5,
                    message: {
                        required: "请输入正确的图形验证码",
                        length: "请输入正确的图形验证码"
                    }
                },
                'email': {
                    required: true,
                    email: true
                    message: {
                        required: "请输入正确的邮箱地址",
                        email: "请输入正确的邮箱地址"
                    }
                }
            ,{}

            # 自定义校验规则，在valid调用之前定义
            validatorData.rule 'length', (val,length)->
                return val.length == length;

            validatorData

module.exports = store;
