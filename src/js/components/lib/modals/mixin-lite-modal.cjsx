###
# Mixin-Lite-Modal.
# @author remiel.
# @component Modal
###
React = require 'react'
Transition = require 'components/lib/transition/transition'

mixinLiteModal =
    _renderLiteModalLayer: (afterTransition) ->
        className = "lite-modal is-for-#{@props.name} modal-at-#{@props.position}"
        className = SP.classSet className,
            "full-screen": @props["full-screen"]
        node = ""
        title = ""
        closeIcon = ""
        if @props.showCloseIcon is yes
            closeIcon =
                <div className="u-pr">
                    <Tappable className="icon icon-delete" onTap={@onCloseClick}></Tappable>
                </div>

        if @props.title?
            title =
                <div className="lite-modal-hd">
                    <span className="lite-modal-hd-name">
                        {@props.title}
                    </span>
                </div>

        if @props.show and afterTransition
            boxClasses = [
                "box"
                "u-ml-" + @props.margin
                "u-mr-" + @props.margin
                ].join " "
            if @props["full-screen"]
                node =
                    <Tappable component="div" className={className} onTap={@onBackdropClick} style={@props.maskStyle}>
                        <Tappable component="div" className="wrapper" onTap={@onBackdropClick}>
                            <Tappable component="div" className={boxClasses} onTap={@onBackdropClick}>
                                {closeIcon}
                                {title}
                                {@props.children}
                            </Tappable>
                        </Tappable>
                    </Tappable>
            else
                node =
                    <div className={className} onClick={@onBackdropClick} style={@props.maskStyle}>
                        <div className="wrapper" onClick={@onBackdropClick}>
                            <div className={boxClasses}>
                                {closeIcon}
                                {title}
                                {@props.children}
                            </div>
                        </div>
                    </div>

        <Transition transitionName="fade" enterTimeout={200} leaveTimeout={350}>
            {node}
        </Transition>

module.exports = mixinLiteModal
