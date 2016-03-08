gulp = require 'gulp'
gutil = require 'gulp-util'
config = require '../configs/config.coffee'

module.exports = (gulp,$)->
    # 输出标识
    console.log gutil.colors.green "                                                                      "
    console.log gutil.colors.green "         _         _                            _      _  _           "
    console.log gutil.colors.green "        (_)       (_)                          | |    (_)| |          "
    console.log gutil.colors.green "    ___  _  _ __   _  _ __    _ __ ___    ___  | |__   _ | |  ___     "
    console.log gutil.colors.green "   / __|| || '_ \\ | || '_ \\  | '_ ` _ \\  / _ \\ | '_ \\ | || | / _ \\    "
    console.log gutil.colors.green "   \\__ \\| || |_) || || | | | | | | | | || (_) || |_) || || ||  __/    "
    console.log gutil.colors.green "   |___/|_|| .__/ |_||_| |_| |_| |_| |_| \\___/ |_.__/ |_||_| \\___|    "
    console.log gutil.colors.green "           | |                                                        "
    console.log gutil.colors.green "           |_|                                                        "
    console.log gutil.colors.green "                                                                      "

    return ()->
        gulp.src [config.staticDevPath]
            .pipe $.rimraf()
