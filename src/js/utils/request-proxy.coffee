Promise = require 'yaku'
log = require './log'
navigate = require './navigate'
message = require './message'

ajaxStatus =
    SUCCESS                 : 0 # 成功
    FAIL                    : 1 # 失败
    ERROR_OPERATION_FAILED  : 10001 # 操作失败
    ERROR_MISSING_PARAM     : 20001 # 缺少参数
    ERROR_INVALID_PARAM     : 20002 # 不合法参数
    ERROR_INVALID_CAPTCHA   : 20003 # 验证码错误
    ERROR_AUTH_FAILED       : 40001 # 未登录操作
    ERROR_PERMISSION_DENIED : 40003 # 权限错误

typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

module.exports = (res)->
    new Promise (resolve, reject) ->
        if res
            switch res.code
                when ajaxStatus.SUCCESS
                    log "success"
                    resolve res
                when ajaxStatus.FAIL
                    log "fail"
                    reject res
                when ajaxStatus.ERROR_OPERATION_FAILED
                    log "操作失败"
                    reject res
                when ajaxStatus.ERROR_MISSING_PARAM
                    log "缺少参数"
                    reject res
                when ajaxStatus.ERROR_INVALID_PARAM
                    log "不合法参数"
                    reject res
                when ajaxStatus.ERROR_INVALID_CAPTCHA
                    log "验证码错误"
                    reject res
                when ajaxStatus.ERROR_AUTH_FAILED
                    log "未登录操作"
                    message {
                        msg: "你还没有登录，请先登录!"
                        callback: ->
                            SP.storage.remove('member')
                            liteFlux.store("member").reset();
                            if !SP.loginboxshow
                                SP.loginboxshow = true
                                SP.loadLogin
                                    success: ->
                                        window.location.reload();
                                    #logoutCallback: ->
                                    #    navigate.redirect '/'
                            #navigate.redirect '/member/login'
                    }
                when ajaxStatus.ERROR_PERMISSION_DENIED
                    log "权限错误"
                    message {
                        msg: "你还没有登录，请先登录!"
                        callback: ->
                            SP.storage.remove('member')
                            liteFlux.store("member").reset();
                            if !SP.loginboxshow
                                SP.loginboxshow = true
                                SP.loadLogin
                                    success: ->
                                        window.location.reload();
                                    #logoutCallback: ->
                                    #    navigate.redirect '/'
                            #navigate.redirect '/member/login'
                    }
        else
            log "网络问题"
