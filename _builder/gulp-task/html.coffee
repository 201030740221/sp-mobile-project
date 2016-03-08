fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
config = require '../configs/config.coffee'
try
    map = require path.join( __dirname, '../../', config.staticPath , '/map.json')
catch
    map = {}
through = require 'through2'

includeUrl = ()->
    return through.obj (file,enc,cb)->
        fileContent = file.contents.toString()
        content = fileContent.replace /__PageCss__/g, '/css/'+map.dependencies.css.main
        content = content.replace /__ConfigJS__/g, '/config.js'
        content = content.replace /__CommonJS__/g, '/js/'+map.commonDependencies.js.common
        content = content.replace /__PageJS__/g, '/js/'+map.dependencies.js.main
        file.contents = new Buffer(content)
        this.push file
        cb()

module.exports = (gulp,$)->
    return ()->
        gulp.src config.dirs.src + '/html/**/*.html'
            .pipe $.newer(config.staticPath)
            .pipe $.plumber()
            .pipe includeUrl()
            .pipe $.size()
            .pipe gulp.dest( config.staticPath )
