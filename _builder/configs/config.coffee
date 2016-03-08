_ = require 'underscore'
configSample = require '../../config.sample'

src_dir = './src'
global_dir = './src/js/global'
configs =
    name: configSample.name || "斯品家居"
    version: configSample.version || "1.0.0"
    description: configSample.description || "斯品家居的前端项目"
    env: configSample.env || "development" # production || development || test
    apiHost: configSample.apiHost || 'http://www.sipin.com/api'     # production api host
    apiTestHost: configSample.apiTestHost || 'http://www.sipin.latest.dev.e.sipin.one/api' # test api host
    dirs:
        src: src_dir,
        dist: "./dist",
        pages: src_dir + "/js/pages",
        modules: src_dir + "/js/modules",
        widgets: src_dir + "/js/widgets",
        components: src_dir + "/js/components",
        global: src_dir + "/js/global",
        vendor: src_dir + "/js/vendor",
        stores: src_dir + "/js/stores",
        mixins: src_dir + "/js/mixins",
        utils: src_dir + "/js/utils",
        webapi: src_dir + "/js/webapis",
        builderDir: './_builder'

devDirs =
    ieRequireList: configs.ieRequireList

    # 静态目录
    staticPath : configs.dirs.dist + '/' + configs.version
    staticDevPath : configs.dirs.dist + '/' + 'dev-' + configs.version

    # 线上
    htmlBuildPath : configs.dirs.dist + '/' +  configs.version + '/html'
    jsBuildPath : configs.dirs.dist + '/' + configs.version + '/js/'
    cssBuildPath : configs.dirs.dist + '/' + configs.version + '/css/'
    imagesBuildPath : configs.dirs.dist + '/' + configs.version + '/images/'
    fontsBuildPath : configs.dirs.dist + '/' + configs.version + '/fonts/'

    # 开发
    htmlDevPath : configs.dirs.dist + '/' +  'dev-'+configs.version + '/html'
    jsDevPath : configs.dirs.dist + '/' +  'dev-'+configs.version + '/js/'
    cssDevPath : configs.dirs.dist + '/' +  'dev-'+configs.version + '//css/'
    imagesDevPath : configs.dirs.dist + '/' +  'dev-'+configs.version + '/images/'
    fontsDevPath : configs.dirs.dist + '/' +  'dev-'+configs.version + '/fonts/'

    # 合并common.css
    baseCssDir : configs.dirs.src + '/css/base/'
    uiCssDir : configs.dirs.src + '/css/modules/ui/'
    utilCssDir : configs.dirs.src + '/css/modules/utils/'
    pageCssDir : configs.dirs.src + '/css/pages/'

    #apidoc.json
    builderDir:  configs.dirs.builderDir

module.exports = _.extend configs,devDirs
