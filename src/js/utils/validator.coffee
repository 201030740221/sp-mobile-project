module.exports = {
    name: (val)->
        /^[\u4e00-\u9fa5]{1,10}[·.]{0,1}[\u4e00-\u9fa5]{1,10}$/.test val
    username: (val)->
        /^[a-zA-Z][\w+]{3,16}$/.test val
    password: (val)->
        /^[\@A-Za-z0-9\!\#\$\%\^\&\*\.\~]{6,22}$/.test val
    phone: (val)->
        /^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$/.test val
    tel: (val)->
        /^\d{3}-\d{7,8}|\d{4}-\d{7,8}|(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$/.test val
    # matches yyyy-MM-dd
    date: (val) ->
        /^[1-2][0-9][0-9][0-9]-[0-1]{0,1}[0-9]-[0-3]{0,1}[0-9]$/.test val

    email: (val) ->
        /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test val

    minLength: (val, length) ->
        val.length >= length

    maxLength: (val, length) ->
        val.length <= length

    equal: (val1, val2) ->
        val1 is val2

    required: (val)->
        val.length > 0

    region: (val)->
        val isnt 'fail'

    # 正则检测
    regex: (val,reg) ->
        re = new RegExp reg
        re.test val
};
