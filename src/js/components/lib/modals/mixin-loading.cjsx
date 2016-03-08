###
# Mixin Loading.
# @author remiel.
# @component Modal
###
Transition = require 'components/lib/transition/transition'

mixinLoading =
    _renderLoadingLayer: (afterTransition) ->
        className = "lite-modal loading-modal is-for-#{@props.name}"
        node = ""
        if @props.show and afterTransition
            node =
                <div className={className} style={@props.maskStyle}>
                    <Loading />
                </div>

        <Transition transitionName="fade" enterTimeout={200} leaveTimeout={350}>
            {node}
        </Transition>

module.exports = mixinLoading
