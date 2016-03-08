###
# Confirm Modal.
# @author remiel.
# @module Modal
# @example ConfirmModal
#
#   jsx:
#    <ConfirmModal>删除</ConfirmModal>
#
# @option title {String} title
# @option content {String} content
# @option cancelText {String} text
# @option confirmText {String} text
# @option cancel {Function} cancel callback
# @option confirm {Function} confirm callback
#
###
React = require 'react'
T = React.PropTypes

ConfirmModal = React.createClass
    propTypes:
        title: T.string
        content: T.string
        contentElement: T.element
        confirmText: T.string
        cancelText: T.string
        confirm: T.func
        cancel: T.func
        margin: T.number

    getDefaultProps: ->
        content: "确认?"
        confirmText: "确定"
        cancelText: "取消"
        confirm: () ->
            # console.log 'ok'
            yes
        cancel: () ->
            # console.log 'no'
        margin: 30


    getInitialState: ->
        showModal: false

    onModalShow: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        @setState
            showModal: yes
    onModalHide: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        @setState
            showModal: no

    confirm:(e) ->
        if @props.confirm
            ret = @props.confirm(e)
            if ret is no
                 # @onModalHide()
            else if ret.then
                ret.then (res) =>
                    # TODO promise 有问题...
                    res = res._responseArgs.resp if typeof res.code is 'undefined'
                    if res.code is 0
                        @onModalHide()
            else
                @onModalHide()
        else
            @onModalHide()

    cancel:() ->
        @onModalHide()
        @props.cancel()

    onTap: (e) ->
        e.preventDefault()
        e.stopPropagation()
        @onModalShow()
        @props.onTap() if @props.onTap?


    renderModal: ->

        if @props.contentElement?
            content = @props.contentElement
        else
            content =
                <div className="u-text-center u-color-black u-pb-20 u-pt-30 u-f16">{@props.content}</div>

        <Modal name="confirm-modal" title={@props.title || ""} onCloseClick={@cancel} show={@state.showModal} margin={@props.margin}>
            {content}
            <div className="u-text-center u-pb-20 u-flex-box">
                <div className="u-flex-item-1 u-pr-5 u-pl-15">
                    <Button onTap={@confirm} block bsStyle='primary'>{@props.confirmText}</Button>
                </div>
                <div className="u-flex-item-1 u-pl-5 u-pr-15">
                    <Button onTap={@cancel} block bsStyle='primary'>{@props.cancelText}</Button>
                </div>
            </div>
        </Modal>
    render: () ->
        <Tappable {...@props} onTap={@onTap}>
            {@props.children}
            {@renderModal()}
        </Tappable>


module.exports = ConfirmModal
