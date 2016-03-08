fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
config = require '../configs/config.coffee'
through = require 'through2'

module.exports = (gulp,$)->

    mapJson =
        version: config.version
        name: "sipin-webstore"
        createdAt: (new Date()).toString()
        commonDependencies: {
            css: {}
            js: {}
        } ,
        dependencies: {
            css: {}
            js: {}
        }


    gulp.task 'buildMap:js',['buildCommon:dev'], ->
        gulp.src [config.jsDevPath + '/common.js',config.jsDevPath + '/main.js','!'+config.jsDevPath+'/_common.js','!'+config.jsDevPath+'/ui - kits.js']
            .pipe $.md5({
                size: 10,
                separator: '.'
            } )
            .pipe $.uglify()
            .pipe $.size()
            .pipe gulp.dest(config.jsBuildPath)
            .pipe $.map (file)->
                _filename = path.basename(file.path).toString() ;
                _filename = _filename.slice(0, _filename.length) ;
                filename = _filename.slice(0, _filename.length - 14) ;
                filename = filename.replace(/-/g,"/") ;
                if(filename == "common" || filename == "ie")
                    mapJson['commonDependencies']['js'][filename] = _filename;
                else
                    mapJson['dependencies']['js'][filename] = _filename;
                return;

    gulp.task 'copyPageJs',['buildMap:js'], ->
        gulp.src [config.jsDevPath + '/*.js','!'+config.jsDevPath + '/common.js','!'+config.jsDevPath + '/main.js' ]
            .pipe $.uglify()
            .pipe $.size()
            .pipe gulp.dest(config.jsBuildPath)
        gulp.src [config.staticDevPath + '/config.js']
            .pipe gulp.dest(config.staticPath)


    gulp.task 'buildMap:css',['images:build','copyPageJs'], ->
        gulp.src config.cssDevPath + '/**/*.css'
            .pipe $.md5({
                size: 10,
                separator: '.'
            } )
            .pipe $.minifyCss()
            .pipe $.size()
            .pipe gulp.dest(config.cssBuildPath)
            .pipe $.map (file) ->
                _filename = path.basename(file.path).toString() ;
                _filename = _filename.slice(0, _filename.length) ;
                filename = _filename.slice(0, _filename.length - 15) ;
                filename = filename.replace(/-/g,"/") ;
                if(filename == "common")
                    mapJson['commonDependencies']['css'][filename] = _filename;
                else
                    mapJson['dependencies']['css'][filename] = _filename;
                return;

    gulp.task 'buildMap:writeMap',['buildMap:css','fonts:build'],->
        fs.writeFileSync( config.staticPath + '/map.json', JSON.stringify(mapJson))

        includeUrl = ()->
            return through.obj (file,enc,cb)->
                fileContent = file.contents.toString()
                content = fileContent.replace /__PageCss__/g, '/css/'+mapJson.dependencies.css.main
                content = content.replace /__ConfigJS__/g, '/config.js'
                content = content.replace /__CommonJS__/g, '/js/'+mapJson.commonDependencies.js.common
                content = content.replace /__PageJS__/g, '/js/'+mapJson.dependencies.js.main
                file.contents = new Buffer(content)
                this.push file
                cb()

        gulp.src config.dirs.src + '/html/**/*.html'
            .pipe $.newer(config.staticPath)
            .pipe $.plumber()
            .pipe includeUrl()
            .pipe $.size()
            .pipe gulp.dest( config.staticPath )


    return ()->
        gulp.start 'buildMap:writeMap'
