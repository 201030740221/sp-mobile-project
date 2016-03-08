###
# Mixin Message.
# @author remiel.
# @component Modal
###
React = require 'react'
Transition = require 'components/lib/transition/transition'

mixinMessage =
    _renderMessageLayer: (afterTransition) ->
        className = "lite-modal message is-for-#{@props.name}"
        node = ""
        if @props.show and afterTransition
            node =
                <div className={className} onClick={@onBackdropClick}>
                    <div className="wrapper" onClick={@onBackdropClick}>
                        <div className="box">
                            {@props.children}
                        </div>
                    </div>
                </div>

        <Transition transitionName="fade" enterTimeout={200} leaveTimeout={350}>
            {node}
        </Transition>

module.exports = mixinMessage
