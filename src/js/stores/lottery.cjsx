store = liteFlux.store "lottery",
    data:
        id: null
        data: null
        prizeList: null
        publicResult: null
        myResult: null
        result: null
        times: null
        tab: 0
        showAlert: no
        attendanceStatus: null

    actions:
        init: () ->

        reset: () ->
            @setStore
                id: null
                data: null
                prizeList: null
                publicResult: null
                myResult: null
                result: null
                times: null
                tab: 0
                showAlert: no
                attendanceStatus: null

        tab: (n) ->
            @setStore
                tab: n

        showAlert: () ->
            @setStore
                showAlert: yes
        hideAlert: () ->
            @setStore
                showAlert: no

        setLotteryId: (id) ->
            @setStore
                id: id

        setResult: (data) ->
            @setStore
                result: data

        setTimes: (data) ->
            @setStore
                times: data

        getPrizeList: (id) ->
            webapi.lottery.getPrizeList(id).then (res) =>
                SP.requestProxy(res).then (res)=>
                    @setStore
                        prizeList: res.data
        getEligibility: (id) ->
            webapi.lottery.getEligibility(id).then (res) =>
                SP.requestProxy(res).then (res)=>
                    @setStore
                        times: res.data.remaining_times
        getPublicResult: (id) ->
            webapi.lottery.getPublicResult(id).then (res) =>
                SP.requestProxy(res).then (res)=>
                    @setStore
                        publicResult: res.data
        getMyResult: (id) ->
            webapi.lottery.getMyResult(id).then (res) =>
                SP.requestProxy(res).then (res)=>
                    @setStore
                        myResult: res.data
        getLottery: (id) ->
            webapi.lottery.getLottery(id).then (res) =>
                SP.requestProxy(res).then (res)=>
                    @setStore
                        data: res.data
                    @getAction().shareWeixinData res.data
        draw: () ->
            store = @getStore()
            @getAction().setTimes(store.times - 1)
            webapi.lottery.draw(store.id).then (res) =>
                SP.requestProxy(res).then (res)=>
                    @setStore
                        result: res.data
                if res.code is 1
                    @setStore
                        result:
                            id: -1
                            lottery_id: -1
                            member_id: -1
                            prize_id: -1
                            prize_name: -1
                            prize_type: -1
                            remaining_times: -1
                    SP.message
                        msg: res.msg


        setAddress: (result_id, address_id) ->
            webapi.lottery.setAddress(result_id, address_id).then (res) =>
                SP.requestProxy(res).then (res)=>
                    SP.message
                        msg: '信息提交成功，请耐心等候发货'
                        type: 'success'

        setAttendance: (type, shareData) ->
            store = @getStore()
            # setTimeout () ->
            #     if type is 2
            #         A('share').onShareWeibo(shareData)
            # , 2222

            webapi.lottery.setAttendance(store.id, type).then (res) =>
                SP.requestProxy(res).then (res)=>
                    if type is 0
                        @setStore
                            attendanceStatus: yes
                        SP.message
                            msg: '签到成功'
                            type: 'success'
                    if type is 2
                        # ua = navigator.userAgent.toLowerCase()
                        # is_weixin = (/MicroMessenger/i).test ua
                        # A('share').onShareWeibo(shareData, not is_weixin)
                        A('share').onShareWeibo(shareData)
                    @setStore
                        times: res.data.remaining_times

        checkAttendance: (id) ->
            webapi.lottery.checkAttendance(id, 0).then (res) =>
                SP.requestProxy(res).then (res)=>
                    @setStore
                        attendanceStatus: res.data



        # 获取分享内容后设置
        shareWeixinData: (data)->
            store = @getStore()
            storeData = data || store.data || {}
            copywritings = storeData.copywritings || {}
            data = copywritings.weixin || {}
            shareData =
                title: data.title || '斯品幸运大转盘' # 分享标题
                desc: data.content || '来斯品参与抽奖，好礼送给你，100中奖哦！'
                link: data.link || window.location.href
                imgUrl: data.pics and data.pics[0] || 'http://7sbwdf.com2.z0.glb.qiniucdn.com/55c0667d7b264_lottery.jpg?imageView2/2/w/200/q/80' # 分享图标
                successCallback: () ->
                    Action.setAttendance 1
            # 设置分享
            A('share').setShareData shareData

        shareWeiboData: ()->
            store = @getStore()
            storeData = store.data || {}
            copywritings = storeData.copywritings || {}
            data = copywritings.weibo || {}
            shareData =
                title: data.title || '斯品幸运大转盘' # 分享标题
                desc: data.content || '来参与斯品家居幸运大转盘活动，好礼送给你，100%中奖哦！'
                link: data.link || window.location.href
                imgUrl: data.pics and data.pics[0] || 'http://7sbwdf.com2.z0.glb.qiniucdn.com/55c0667d7b264_lottery.jpg' # 分享图标

module.exports = store;
