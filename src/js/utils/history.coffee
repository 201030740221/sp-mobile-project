###
# 历史记录
# @description 后退事件作历史记录依据
# @param {array} stack 历史记录
# @param {number} index 历史记录长度
# @param {function} getCurrent 获取当前页面记录
# @param {function} getPrev 获取上一页面记录
# @param {function} getNext 获取下一页面记录
# @param {function} sff 增加新页面页面记录
# @param {function} back 删除页面记录，后退一步
###
class History
    constructor: ->
        @stack = []
        @index = 0

    getNext: ->
        @stack[@index+1]

    getPrev: ->
        @stack[@index-1]

    getCurrent: ->
        @stack[@index]

    add: (page)->
        if @getNext()
            @clearForward()

        @stack.push page
        @index = @stack.length - 1
        @getCurrent()

    back: ->
        if @getCurrent()
            @clearForward()

        if @stack.length>1
            @stack.pop()
            @index = this.stack.length - 1
            @getCurrent()
        else
            false

    clearForward: ->
        @stack = @stack.slice 0, @index + 1


module.exports = new History();
