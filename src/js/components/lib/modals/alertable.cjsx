###
# Alertable Modal.
# @author remiel.
# @module Modal
# @example AlertModal
#
#   jsx:
#    <Alertable>?</Alertable>
#
# @option title {String} title
# @option content {String} content
#
###
React = require 'react'
T = React.PropTypes

Alertable = React.createClass
    propTypes:
        title: T.string
        content: T.string
        contentElement: T.element
        confirmText: T.string
        margin: T.number
        showCloseIcon: T.bool
        showConfirmBtn: T.bool
        maskClose: T.bool

    getDefaultProps: ->
        confirmText: "我知道了"
        content: "确认?"
        margin: 30
        showCloseIcon: no
        showConfirmBtn: yes
        maskClose: no

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

    cancel:() ->
        if @props.callback
            if @props.callback()
                @onModalHide()
        else
            @onModalHide()


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
                <div className="u-text-center u-color-black u-pt-20 u-f14">{@props.content}</div>

        if @props.showConfirmBtn is yes
            confirmBtn =
                <div className="u-text-center u-pb-20 u-pt-20 u-flex-box">
                    <div className="u-flex-item-1 u-pr-5 u-pl-15">
                        <Button onTap={@cancel} large bsStyle={@props.bsStyle || "primary"}>{@props.confirmText}</Button>
                    </div>
                </div>
        else
            confirmBtn = <div className="u-pt-20"></div>
        <Modal name="alert-modal" title={@props.title || ""} onCloseClick={@cancel} show={@state.showModal} margin={30} showCloseIcon={@props.showCloseIcon} maskClose={@props.maskClose}>
            {content}
            {confirmBtn}
        </Modal>
    render: () ->
        <Tappable {...@props} onTap={@onTap}>
            {@props.children}
            {@renderModal()}
        </Tappable>


module.exports = Alertable
