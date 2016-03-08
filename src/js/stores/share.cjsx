assign = require 'utils/assign'
sinaWeiboShare = require 'utils/sinaWeiboShare'
store = liteFlux.store "share",
    data:
        shareData:
            title: '斯品家居商城 - www.sipin.com', # 分享标题
            desc: "斯品，让居家生活更美好。年轻人的居家生活态度。"
            link: location.href, # 分享链接
            imgUrl: 'http://7viii7.com2.z0.glb.qiniucdn.com/2015/07/15/72f2d4ce_share-logo.jpg', # 分享图标
            weiboAppKey: "1229563682"
            successCallback: () ->
        qrcode: null
        qrcodeUrl: "http://www.sipin.com"
    actions:
        resetQrcode: () ->
            @setStore
                qrcode: null
                qrcodeUrl: "http://www.sipin.com"

        getQrcode: () ->
            url = @getStore().qrcodeUrl
            # webapi.tools.qrcode({url:url,return_type: 'image'}).then (res) =>
            #     @setStore
            #         qrcode: res

        setQrcodeUrl: (url) ->
            @setStore
                qrcodeUrl: url

        onShareQrcode: (url) ->
            @getAction().setQrcodeUrl url
            SP.redirect "/share/weixin/" + encodeURIComponent(url)

        getShareData: (shareData)->
            return assign S('share').shareData, shareData

        setShareData: (shareData)->
            S("share",{
                shareData: shareData
            })
            A('share').setWeixinShareButton();

        resetShareData: ->
            S('share',{
                shareData:
                    title: '斯品家居商城 - www.sipin.com', # 分享标题
                    desc: "斯品，让居家生活更美好。年轻人的居家生活态度。"
                    link: location.href, # 分享链接
                    imgUrl: 'http://7viii7.com2.z0.glb.qiniucdn.com/2015/07/15/72f2d4ce_share-logo.jpg', # 分享图标
                    weiboAppKey: "1229563682"
                    successCallback: () ->
            });
            A('share').setWeixinShareButton();

        setWeixinShareButton: ->

            shareData = A('share').getShareData();

            window.wx && wx.ready ->
                # 分享朋友圈
                wx.onMenuShareTimeline
                    title: shareData.title, # 分享标题
                    desc: shareData.desc
                    link: shareData.link , # 分享链接
                    imgUrl: shareData.imgUrl, # 分享图标
                    success: shareData.successCallback


                # 分享到朋友
                wx.onMenuShareAppMessage
                    title: shareData.title, # 分享标题
                    desc: shareData.desc
                    link: shareData.link , # 分享链接
                    imgUrl: shareData.imgUrl, # 分享图标
                    success: shareData.successCallback

                # 分享到 QQ
                wx.onMenuShareQQ
                    title: shareData.title, # 分享标题
                    desc: shareData.desc
                    link: shareData.link , # 分享链接
                    imgUrl: shareData.imgUrl, # 分享图标
                    success: shareData.successCallback

                # 分享到微博
                wx.onMenuShareWeibo
                    title: shareData.title, # 分享标题
                    desc: shareData.desc
                    link: shareData.link , # 分享链接
                    imgUrl: shareData.imgUrl, # 分享图标
                    success: shareData.successCallback

        initWeixinShare: ()->


            data =
                url: location.href.split('#')[0]

            webapi.referral.getWeixinConfig(data).then (res) =>

                # 微信配置
                window.wx && wx.config
                    debug: false,
                    appId: res.data.appid,
                    timestamp: res.data.timestamp,
                    nonceStr: res.data.noncestr,
                    signature: res.data.signature,
                    jsApiList: [
                        "onMenuShareTimeline",
                        "onMenuShareAppMessage",
                        "onMenuShareQQ",
                        "onMenuShareWeibo",
                        "hideOptionMenu",
                        "showOptionMenu"
                    ]

                A('share').setWeixinShareButton();



        onShareWeibo: (shareData, _blank)->
            shareData = A('share').getShareData(shareData);

            sinaWeiboShare.action
                text: shareData.desc
                url: shareData.link
                pic: shareData.imgUrl # 分享图标
                appkey: shareData.weiboAppKey
            , _blank




module.exports = store;
