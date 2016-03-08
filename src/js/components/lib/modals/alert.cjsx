###
# Alert Modal.
# @author remiel.
# @module Modal
# @example AlertModal
#
#   jsx:
#    <Alert>?</Alert>
#
# @option title {String} title
# @option content {String} content
#
###
React = require 'react'
T = React.PropTypes

Alert = React.createClass
    propTypes:
        title: T.string
        confirmText: T.string
        confirmBtnElement: T.element
        showCloseIcon: T.bool
        showConfirmBtn: T.bool
        confirm: T.func
        cancel: T.func
        margin: T.number



    getDefaultProps: ->
        confirmText: "我知道了"
        showCloseIcon: no
        showConfirmBtn: yes
        margin: 30
        confirm: () ->
            yes
        cancel: () ->


    getInitialState: ->
        showModal: false

    componentDidMount: ->
        # @onModalShow()
        @updateShow @props.show

    componentWillReceiveProps: (props) ->
        # @onModalShow()
        @updateShow props.show

    updateShow: (show) ->
        if show is yes
            @onModalShow()
        else
            @onModalHide()

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
        @onModalHide()
        @props.cancel()

    confirm: (e) ->
        if @props.confirm
            ret = @props.confirm(e)
            if ret is no
                # @onModalHide()
            else if typeof ret is 'object' and ret.then
                ret.then (res) =>
                    if res.code is 0
                        @onModalHide()
            else
                @onModalHide()
        else
            @onModalHide()

    # onTap: (e) ->
    #     e.preventDefault()
    #     e.stopPropagation()
    #     @onModalShow()
    #     @props.onTap() if @props.onTap?

    render: ->

        if @props.showConfirmBtn is yes

            if @props.confirmBtnElement
                confirmBtn = @props.confirmBtnElement
            else
                confirmBtn =
                    <div className="u-text-center u-pb-20 u-pt-20 u-flex-box">
                        <div className="u-flex-item-1 u-pr-5 u-pl-15">
                            <Button onTap={@confirm} large bsStyle={@props.bsStyle || "primary"}>{@props.confirmText}</Button>
                        </div>
                    </div>
        else
            confirmBtn = <div className="u-pt-20"></div>
        modalName = @props.name || "alert-modal"
        <Modal name={modalName} title={@props.title || ""} onCloseClick={@cancel} show={@state.showModal} margin={@props.margin} showCloseIcon={yes}>
            {@props.children}
            {confirmBtn}
        </Modal>


module.exports = Alert
