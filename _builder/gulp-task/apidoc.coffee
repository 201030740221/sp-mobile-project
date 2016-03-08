fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
config = require '../configs/config.coffee'


module.exports = (gulp,$)->
    return ()->
        # gulp.src ['gulpfile.coffee',config.dirs.src + '/js/global/*.coffee']
        #     .pipe $.coffee({bare: true} )
        #     .pipe $.doxit()
        #     .pipe gulp.dest( './doc/global' )

        gulp.src [config.dirs.src + '/js/webapis/*.js']
            .pipe $.apiDoc({
                markdown: true
            })
            .pipe gulp.dest( './doc/api' )
