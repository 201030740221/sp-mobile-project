###
# Textarea.
# @author remiel.
# @module Textarea
# @example Textarea
#
#   jsx:
#   <Textarea></Textarea>
#
# http://stackoverflow.com/questions/454202/creating-a-textarea-with-auto-resize
###

React = require 'react'
T = React.PropTypes

Textarea = React.createClass

    propsType:
        onChange: T.func
        autoResize: T.boolean

    getDefaultProps: ->
        autoResize: no


    onChange: (e) ->
        @props.onChange(e) if @props.onChange
        @resize() if @props.autoResize

    resize: () ->
        el = @refs.textarea.getDOMNode()
        el.style.height = 'auto'
        el.style.height = el.scrollHeight + 'px'

    render: ->
        <textarea rows="1" defaultValue={@props.children} {...@props} ref='textarea' onChange={@onChange}/>

module.exports = Textarea
