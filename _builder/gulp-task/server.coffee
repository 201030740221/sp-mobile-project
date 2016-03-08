fs = require 'fs'
url = require 'url'
path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
config = require '../configs/config.coffee'
browserSync = require 'browser-sync'
proxyMiddleware = require 'http-proxy-middleware'
reload = browserSync.reload

try
    developConfig = require path.join( __dirname, '../../', 'config.json')
catch
    developConfig =
        isProxy: false
        apiDevHost: 'http://www.sipin.latest.dev.e.sipin.one'

#urlReg = /[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?(\:[0-9]{0,5})?/

module.exports = (gulp,$)->
    return ()->

        # 获得代理域名
        middlewareProxy = []
        if developConfig.isProxy
            url = url.parse developConfig.apiDevHost

            middlewareProxy.push proxyMiddleware '/api', {
                target: 'http://'+url.host
                proxyHost: '0.0.0.0'
            }

        browserSync(
            port: 7000
            ui: false
            server:
                baseDir: [ config.staticDevPath]
            files: [ config.staticDevPath+ '/**']
            logFileChanges: false
            middleware: middlewareProxy
            ghostMode: false #Clicks, Scrolls & Form inputs on any device will be mirrored to all others.
            notify: false #The small pop-over notifications in the browser are not always needed/wanted.
            open: "external"
        )

        #css and sprite
        gulp.watch [config.dirs.src + '/css/**/*.styl',config.dirs.src + '/images/slice/*.png'], ['sprite:dev']
        #js
        gulp.watch config.dirs.src + '/js/?(modules|pages|widgets|components|utils|mixins|stores|webapis|vendor)/**/*.?(coffee|js|jsx|cjsx|hbs|styl|css)', ['buildCommon:dev']
        #html
        gulp.watch config.dirs.src + '/html/**/*.html', ['html']
