###
# Modal.
# @author remiel.
# @module Modal
# @example Modal
#
#   jsx:
#    <Modal name="cart-delete" title="this is title" onCloseClick={@onModalHide} showClose={true} show={@state.showModal}>
#        <div className="u-text-center u-pb-20 u-pt-30">确认删除选中商品?</div>
#        <div className="u-text-center u-pb-20">
#            <Button className="u-mr-20" onTap={@onDelete}>删除</Button>
#            <Button onTap={@onModalHide}>取消</Button>
#        </div>
#    </Modal>
#
# @param options {Object} the options
# @option name {String} 命名空间
# @option title {String} title
# @option onCloseClick {Function} close callback
# @option maskClose {Boolean} 点击遮罩是否促发关闭
# @option showCloseIcon {Boolean} 显示关闭icon
# @option show {Boolean}
# @option type {String} 'lite-modal' || 'messgae' || 'loading', default: 'lite-modal'
# @option margin {Number} 5,10,15等 增加内容层的margin, default: {15}
# @option position {String} 'top', 'center', 'bottom' default: 'center' 弹出层出现的位置
# @option maskStyle {Object} mask css , default: {}
###

React = require 'react'

Transition = require 'components/lib/transition/transition'

Mixins = require '../mixins/index'
# mixinLayered = require 'mixins/mixin-layered'
mixinLiteModal = require './mixin-lite-modal'
mixinMessage = require './mixin-message'
mixinLoading = require './mixin-loading'

T = React.PropTypes

Modal = React.createClass
    mixins: [Mixins.layered, mixinLiteModal, mixinMessage, mixinLoading]

    propTypes:
        # this components accepts children
        name:             T.string
        title:            T.string
        onCloseClick:     T.func.isRequired
        showCornerClose:  T.bool
        show:             T.bool.isRequired
        type:             T.string
        margin:           T.number
        position:         T.string
        maskStyle:        T.object
        maskClose:        T.bool # 点击遮罩是否促发关闭
        showCloseIcon:    T.bool # 显示关闭的icon

    getDefaultProps: ->
        type: 'lite-modal'
        margin: 15
        position: 'center'
        maskStyle: {}
        maskClose: no
        showCloseIcon: no

    getInitialState: ->
        if @props.type is 'message'
            @timer = null
        {}

    onCloseClick: ->
        @props.onCloseClick()

    onBackdropClick: (event) ->
        if @props.maskClose and event.target is event.currentTarget
            @onCloseClick()

    renderLayer: (afterTransition) ->
        node = ''
        switch @props.type
            when 'lite-modal'
                node = @_renderLiteModalLayer afterTransition
            when 'message'
                node = @_renderMessageLayer afterTransition
            when 'loading'
                node = @_renderLoadingLayer afterTransition

        node

    render: ->
        <span></span>

module.exports = Modal
