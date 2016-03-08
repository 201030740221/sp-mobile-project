config = require './config'
module.exports = ->
    args = Array.prototype.slice.call(arguments)
    if(args.length==1)
        args = args[0]
    config.debug && console && console.log( args )
