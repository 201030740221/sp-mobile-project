###
# Confirm Modal.
# @author remiel.
# @module Modal
# @example ConfirmModal
#
#   jsx:
#    <ConfirmModal />
#
# @option show {Boolean}
# @option title {String} title
# @option content {String} content
# @option cancelText {String} text
# @option confirmText {String} text
# @option cancel {Function} cancel callback
# @option confirm {Function} confirm callback
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

    getDefaultProps: ->
        content: "确认?"
        confirmText: "确定"
        cancelText: "取消"
        confirm: () ->
            # console.log 'ok'
        cancel: () ->
            # console.log 'no'


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

    confirm:() ->
        @onModalHide()
        @props.confirm()

    cancel:() ->
        @onModalHide()
        @props.cancel()

    render: () ->

        if @props.contentElement?
            content = @props.contentElement
        else
            content =
                <div className="u-text-center u-color-black u-pb-20 u-pt-30 u-f16">{@props.content}</div>

        <Modal name="confirm-modal" title={@props.title || ""} onCloseClick={@cancel} show={@props.show} margin={30}>
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


module.exports = ConfirmModal
