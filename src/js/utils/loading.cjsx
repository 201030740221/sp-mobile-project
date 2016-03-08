###
# loading.
# @author remiel.
# @module loading
###

# msgs = []
module.exports = (show)->
    containerName = 'modal-loading'
    container = document.getElementById containerName
    if !container
        container = document.createElement 'div'
        container.id = containerName
        document.body.appendChild container

    React.render(
        <LoadingModal show={show}/>,
        container
    )
