###
# Checkbox.
# @author remiel.
# @module Checkbox
# @example Checkbox
#
#   jsx:
#   <Checkbox checked={true} onChange={()->}></Checkbox>
#   <Checkbox checked={true} onChange={()->} type='switch'></Checkbox>
#
# @param options {Object} the options
# @option onChange {Function} onChange callback
# @option checked {Boolean} default checked value
# @option type {String} default is 'checkbox' , it can be 'switch'
#
###
SP = require 'SP'
React = require 'react'
Tappable = require 'react-tappable'

T = React.PropTypes

Checkbox = React.createClass

    propTypes:
        onChange: T.func
        checked: T.bool
        type: T.string

    getDefaultProps: ->
        onChange: (checked)->
            console.log checked
        checked: true
        type: 'checkbox'

    getInitialState: ->
        @shouldUpdate = false
        checked: @props.checked

    componentWillReceiveProps: (nextProps) ->
        @setState
            checked: nextProps.checked
        @shouldUpdate = true

    handleChange: ->
        checked = !@state.checked
        @setState checked: checked
        @props.onChange checked

    render: ->
        checked = if @shouldUpdate then @props.checked else @state.checked
        @shouldUpdate = false
        classes = SP.classSet
            'checkbox': @props.type is 'checkbox'
            'checkbox-switch': @props.type is 'switch'
            'active': checked
        <Tappable className={classes} onTap={@handleChange}>
            <input ref="input" type="checkbox" defaultChecked={checked} />
            {@props.children}
        </Tappable>

module.exports = Checkbox
