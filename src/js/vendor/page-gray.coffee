module.exports =
    addGrayFilter: ->
        document.getElementsByTagName('html')[0].className = "page-gray"
    removeGrayFilter: ->
        document.getElementsByTagName('html')[0].className = ""
