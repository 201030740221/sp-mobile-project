wx.ready ->
    # 分享朋友或者朋友圈
    wx.onMenuShareAppMessage(sipinConfig.shareData);
    wx.onMenuShareTimeline(sipinConfig.shareData);
