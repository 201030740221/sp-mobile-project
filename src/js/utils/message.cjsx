###
# Message.
# @author remiel.
# @module Message
###

# msgs = []
module.exports = (opts)->
    # msg, type, duration, callback
    # type未实现
    containerName = 'modal-message'
    container = document.getElementById containerName
    if !container
        container = document.createElement 'div'
        container.id = 'modal-message'
        document.body.appendChild container
    # 多条重叠
    # item = document.createElement 'div'
    # container.appendChild item

    children = opts.msg
    if typeof opts.msg is 'function'
        children = <children />

    # msgs.push children
    # node = msgs.map (_item, i) ->
    #     <div key={i}>{_item}</div>


    duration = opts.duration || 2500
    callback = opts.callback || () ->

    React.render(
        <Message duration={duration} callback={callback}>{children}</Message>,
        container
    )
