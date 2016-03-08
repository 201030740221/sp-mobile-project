###
# Message.
# @author remiel.
# @module Message
###
React = require 'react'

LoginModal = require 'modules/lib/modal-login'
# msgs = []
module.exports = (opts)->
    # msg, type, duration, callback
    # type未实现
    containerName = 'modal-login'
    container = document.getElementById containerName
    if !container
        container = document.createElement 'div'
        container.id = 'modal-login'
        document.body.appendChild container

    callback = opts && opts.callback || () ->

    React.render(
        <LoginModal callback={callback}></LoginModal>,
        container
    )
