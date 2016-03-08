request = require('./request')
classSet = require('./class-set')
assign = require('./assign')
thumb = require('./thumb')
promise = require 'yaku'
request = require './request'
#request = require './request'
navigate = require './navigate'
config = require './config'
message = require './message'
alert = require './alert'
Calc = require './calc'
validator = require './validator'
Store = require './storage'
cookie = require './cookie'
classNames = require 'classnames'
loginbox = require './login-modal'
log = require './log'
requestProxy = require './request-proxy'
raf = require './raf'
loading = require './loading'
event = require './event'

SP =
    # 设置文件
    config: config
    # debug
    log: log
    #ajax: ajax
    request: request
    ajax: request
    classSet: classNames
    assign: assign
    promise: promise
    # 弱提示框 param: object(text, type, duration, callback)
    # type 暂未实现
    message: message
    # Alert param: object(content, title, confirm, cancel)
    alert: alert
    loginboxshow: false,
    loginbox: loginbox
    loadLogin: require './login-modal-page'
    # Loading-Modal 参数(Boolean) ture 显示, false 隐藏
    loading: loading
    # 通过路由跳转页面
    redirect: navigate.redirect
    back: navigate.back
    # 字符串处理
    trim: (val)->
        if !val
            return val
        return val.replace /^\s+|\s+$/gm,''
    calc: Calc
    validator: validator
    storage: new Store()
    cookie: cookie
    # 用户登录权限相关的接口，用这个方法进行拦截相关处理
    requestProxy: requestProxy
    # 删除数组中的值，传数组与下标
    removeArray: (arr, n)->
        if(n<0)
            return arr
        else
            return arr.slice(0,n).concat(arr.slice(n+1,arr.length))
    isArray: (value)->
        Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'
    isWeixinBrowser: ->
        regexp = /micromessenger/i
        return regexp.test navigator.userAgent
    getWeixinVersion: ->
        versions = navigator.userAgent.match(/MicroMessenger\/([\d\.]+)/i)
        if versions and versions.length is 2
            return parseFloat versions[1]
        else 
            return 0

    event: event
    isLogin: ->
        member = this.storage.get('member') or {}
        return member.name



assign(SP, thumb);

module.exports = SP;
