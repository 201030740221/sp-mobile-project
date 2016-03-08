
timeManage = require('utils/time-manage')
store = liteFlux.store "activity-november",{
    data:
        {}

    actions:
        getActivityCoupon: (data , callback) ->
            webapi.activity.getPageCoupon({}) .then (res) =>
                if res.code is 0
                    callback && callback res.data


        remind: (mobile_val) ->
            reg = /^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$/;
            if (reg.test(mobile_val))
                webapi.tools.reminderStatus({type: 3}) .then (res) =>
                    SP.requestProxy(res).then (res)=>
                        SP.message
                            msg: '您已设置提醒'


                webapi.tools.reminder
                    types: [3,4,5]
                    target: mobile_val
                .then (res)->
                    SP.requestProxy(res).then (this_res)=>
                        if res.code is 0
                           SP.message
                                  msg: '设置成功'
                        else
                            SP.message
                               msg: res.msg
            else
                SP.message
                    msg: '号码格式错误！'
            false

        getCoupon: (coupon_id, title, content, text_content) ->
            if timeManage.before('2015-11-13 16:00:00')
                webapi.coupon.take task_id: coupon_id
                    .then (res)->
                        if res.code is 0
                            SP.requestProxy(res).then (this_res)=>
                                SP.alert
                                   title: title,
                                   content: text_content,
                                   confirmText: '知道啦',
                                   showCloseIcon: no
                                   bsStyle: 'red'
                        else if res.code is 40001
                             SP.requestProxy(res).then (this_res)=>
                                 SP.message
                                    msg: res.msg
                        else
                             SP.message
                                 msg: res.msg
            else
                alert('活动已结束');


         setAttendance: (type, shareData) ->
            webapi.lottery.setAttendance(store.id, type).then (res) =>
                SP.requestProxy(res).then (res)=>
                    if type is 2
                        A('share').onShareWeibo(shareData)

         getNovemberSecond: (data , callback) ->
            webapi.activity.getNovemberSecond({}) .then (res) =>
                if res.code is 0
                    callback && callback res.data

         getFlashSaleStatus: (data , callback) ->
            webapi.activity.getFlashSaleStatus(data) .then (res) =>
                if res.code is 0
                    callback && callback res.data
}

module.exports = store;
