###
# Message.
# @author remiel.
# @module Message
###
Modal = require 'components/lib/modals/modal'

React = require 'react'
T = React.PropTypes

Message = React.createClass

    propTypes:
        duration: T.number
        callback: T.func

    getDefaultProps: ->
        duration: 2500
        callback: () ->

    getInitialState: ->
        show: false

    componentDidMount: ->
        @onShow()
        @setTimeout()

    componentWillReceiveProps: (nextProps) ->
        @onShow()
        @setTimeout()

    setTimeout: () ->
        clearTimeout @timer
        @timer = setTimeout =>
            @onHide()
        , @props.duration



    onShow: () ->
        @setState
            show: true

    onHide: ->
        clearTimeout @timer
        @props.callback()
        @setState
            show: false

    render: ->
        <Modal name="message" onCloseClick={@onHide} show={@state.show} maskClose={true} type="message" duration={@props.duration}>
            {@props.children}
        </Modal>

module.exports = Message
