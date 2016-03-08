fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
config = require '../configs/config.coffee'
through = require 'through2'

includeUrl = ()->
    return through.obj (file,enc,cb)->
        fileContent = file.contents.toString()
        content = fileContent.replace /__PageCss__/g, '/css/main.css'
        content = content.replace /__ConfigJS__/g, '/config.js'
        content = content.replace /__CommonJS__/g, '/js/common.js'
        content = content.replace /__PageJS__/g, '/js/main.js'
        file.contents = new Buffer(content)
        this.push file
        cb()

module.exports = (gulp,$)->
    return ()->
        gulp.src config.dirs.src + '/html/**/*.html'
            .pipe $.newer(config.staticDevPath)
            .pipe $.plumber()
            .pipe includeUrl()
            .pipe $.fileInclude({
                prefix: '@@',
                basepath: '@file',
                context: {
                    dev: !gutil.env.production
                }
            } )
            .pipe $.size()
            .pipe gulp.dest( config.staticDevPath )
