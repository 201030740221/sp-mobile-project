detect = require('react-mini-router/lib/detect')

module.exports =
    redirect: (url,replace)->

        if replace
            window.history.replaceState({}, '', '#!' + url);
            SP.event.emit "router.setpath", url
        else
            window.location.hash = '#!' + url;

        pageHistory.add
            url: url

    back: (level)->
        # 关闭弹窗
        SP.alert({
            show: false
        });
        pageHistory.back()
        window.history.back level || -1
