fs = require('fs')
path = require('path')
gulp = require('gulp')
gutil = require('gulp-util')

browserSync = require 'browser-sync'
reload = browserSync.reload

# Load plugins
$ = require('gulp-load-plugins')()

getTask = (task)->
    require('./_builder/gulp-task/'+task)(gulp,$)

# 清理dist/目录
gulp.task 'clean:build', getTask('clean-build')

# 清理dist/dev目录
gulp.task 'clean:dev', getTask('clean-dev')


# init
gulp.task 'init:config', getTask('init-config')

# page.css
gulp.task 'pagecss:dev', getTask('css-pages')

# 雪碧图
gulp.task 'sprite:dev', ['pagecss:dev','images:dev'], getTask('sprite')

# 对图像资源复制至dist
gulp.task 'images:dev', getTask('images-dev')
gulp.task 'images:build', ['sprite:dev'], getTask('images-build')

# 对字体图标资源复制至dist
gulp.task 'fonts:dev', getTask('fonts-dev')
gulp.task 'fonts:build', getTask('fonts-build')

#本地资源静态DEMO服务器
gulp.task "server", ['buildCommon:dev','html:dev','fonts:dev','sprite:dev'] , getTask('server')

# 编译webpack未压缩的资源
gulp.task 'webpack:dev',['init:config'], getTask('webpack')

# 编译 api 文档
gulp.task 'apidoc', getTask('apidoc')

# 默认启动本地DEMO服务器
gulp.task 'default',['clean:dev'], ->
    gulp.start 'server'

# 构建任务，生成未压缩版
gulp.task 'buildCommon:dev',['webpack:dev']

#build map.json
gulp.task 'map',['clean:dev','clean:build'], getTask('map')

# 对静态页面进行编译
gulp.task 'html',getTask('html')
gulp.task 'html:dev', getTask('html-dev')

# 构建任务，生成压缩版与未压缩版
gulp.task 'build',['map']
