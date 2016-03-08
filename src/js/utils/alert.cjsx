###
# Alert.
# @author remiel.
# @module Alert
###

# msgs = []
module.exports = (opts)->
    containerName = 'modal-alert'
    container = document.getElementById containerName
    if !container
        container = document.createElement 'div'
        container.id = containerName
        document.body.appendChild container

    children = opts.content
    if typeof opts.content is 'function'
        children = <children />

    confirm = opts.confirm || () ->
        yes
    cancel = opts.cancel || () ->

    bsStyle = opts.bsStyle
    if opts.show is no
        show = no
    else
        show = yes

    name = if opts.name then opts.name else "alert-modal"
    margin = if opts.margin then opts.margin else 30
    confirmText = if opts.confirmText then opts.confirmText else '我知道了'

    React.render(
        <Alert title={opts.title} name={name} confirm={confirm} cancel={cancel} bsStyle={bsStyle} show={show} margin={margin} confirmText={confirmText}>{children}</Alert>,
        container
    )
