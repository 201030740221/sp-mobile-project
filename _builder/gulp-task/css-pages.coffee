fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
config = require '../configs/config.coffee'
through = require 'through2'

includeCssList = () ->
    requireCssList = '/* =============== BASE =============== */\n';

    #引进base.scss
    requireCssList += '@import "../../base/index";\n';

    #引进utils css
    requireCssList += '/* =============== UTILS =============== */\n';
    fs.readdirSync(config.utilCssDir).forEach (item) ->
        requireCssList += '@import "../../modules/utils/'+item+'";\n';

    #引进ui css
    requireCssList += '/* =============== UI =============== */\n';
    fs.readdirSync(config.uiCssDir).forEach (item) ->
        requireCssList += '@import "../../modules/ui/'+item+'";\n';

    requireCssList += '/* =============== MAIN =============== */\n';
    return requireCssList

includeBaseCss = ()->
    return through.obj (file,enc,cb)->
        content = file.contents.toString().replace /\/\* @IMPORT BASE \*\//g, includeCssList()
        file.contents = new Buffer(content)
        this.push file
        cb()

module.exports = (gulp,$)->
    return ()->

        entryArr = [];
        fs_pageCssDir = fs.readdirSync(config.pageCssDir) ;
        fs_pageCssDir.forEach (item) ->
            if (fs.statSync(config.pageCssDir + item).isDirectory())
                pageCssDirPath = config.pageCssDir + item
                if( !fs.existsSync(pageCssDirPath + '/'+item+'.styl') )
                    pageCssDirFiles = fs.readdirSync(pageCssDirPath) ;
                    pageCssDirFilesPaths = [];
                    pageCssDirFiles.forEach (file) ->
                        pageCssDirFilesPaths.push(pageCssDirPath + '/' + file)
                    if(pageCssDirFilesPaths.length)
                        gulp.src pageCssDirFilesPaths
                        .pipe $.newer(config.cssDevPath + item + ".styl")
                        .pipe $.plumber()
                        .pipe $.concat(item + ".styl")
                        #.pipe $.sourcemaps.init()
                        .pipe $.stylus()
                        .pipe $.autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4')
                        .pipe $.size()
                        .pipe gulp.dest(config.cssDevPath)
                        #.pipe $.sourcemaps.write('./')
                        #.pipe gulp.dest(config.cssDevPath)
                else
                    entryArr.push(pageCssDirPath + '/'+item+'.styl') ;

        gulp.src entryArr
        .pipe $.newer(config.cssDevPath)
        .pipe $.plumber()
        #.pipe $.replace /\/* @IMPORT BASE *\//g, '@import "../../base/index"'
        # .pipe $.map (file)->
        #     console.log(file.contents.toString())
        .pipe includeBaseCss()
        #.pipe $.sourcemaps.init()
        .pipe $.stylus()
        .pipe $.autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4')
        .pipe $.size()
        .pipe gulp.dest(config.cssDevPath)
        #.pipe $.sourcemaps.write('./')
        #.pipe gulp.dest(config.cssDevPath)
