# fs = require 'fs'
# url = require 'url'
# path = require 'path'
# gulp = require 'gulp'
# gutil = require 'gulp-util'
# config = require '../configs/config.coffee'
# nodeFile = require 'node-file'
#
# module.exports = (gulp,$)->
#     return ()->
#         configSample = require path.join(__dirname, '../../', 'config.sample')
#         configSample.apiHost = gutil.env.apihost || "http://www.sipin.latest.dev.e.sipin.one/api"
#         console.log configSample
#         nodeFile.writeFileSync( path.join( config.staticDevPath,'config.js' ), configSample.toString());
#


fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
config = require '../configs/config.coffee'
through = require 'through2'

includeDevUrl = ()->
    return through.obj (file,enc,cb)->
        fileContent = file.contents.toString()
        content = fileContent.replace /module\.exports/g, 'window.sipinConfig'
        content = content.replace /__ENV__/g, gutil.env.env || 'development'
        content = content.replace /__APIHOST__/g, gutil.env.apihost || 'http://api.m.sipin.com'
        content = content.replace /__APITESTHOST__/g, gutil.env.apitesthost || 'http://api.m.sipin.com'
        content = content.replace /__WEBSOCKET__/g, gutil.env.websocket || 'ws://push.sipin.latest.dev.e.sipin.one/'
        file.contents = new Buffer(content)
        this.push file
        cb()

includeUrl = ()->
    return through.obj (file,enc,cb)->
        fileContent = file.contents.toString()
        content = fileContent.replace /module\.exports/g, 'window.sipinConfig'
        content = content.replace /__ENV__/g, gutil.env.env || 'production'
        content = content.replace /__APIHOST__/g, gutil.env.apihost || 'http://api.m.sipin.com'
        content = content.replace /__APITESTHOST__/g, gutil.env.apitesthost || 'http://api.m.sipin.com'
        content = content.replace /__WEBSOCKET__/g, gutil.env.websocket || 'ws://push.sipin.latest.dev.e.sipin.one/'
        file.contents = new Buffer(content)
        this.push file
        cb()

module.exports = (gulp,$)->
    return ()->
        gulp.src './config.sample.js'
            .pipe $.newer(config.staticDevPath)
            .pipe $.plumber()
            .pipe includeDevUrl()
            .pipe $.size()
            .pipe $.rename("config.js")
            .pipe gulp.dest( config.staticDevPath )

        gulp.src './config.sample.js'
            .pipe $.newer(config.staticDevPath)
            .pipe $.plumber()
            .pipe includeUrl()
            .pipe $.uglify()
            .pipe $.size()
            .pipe $.rename("config.js")
            .pipe gulp.dest( config.staticPath )
