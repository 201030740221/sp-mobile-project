/**
 * alias
 * @wilson
 */

var path = require('path');
var configs = require('./config');

module.exports = {
    'sipinConfig': path.join(__dirname, '../../', configs.staticDevPath+'/config.json'),
    'pages': path.join(__dirname, '../../', configs.dirs.pages),
    'vendor': path.join(__dirname, '../../', configs.dirs.vendor),
    'modules': path.join(__dirname, '../../', configs.dirs.modules),
    'components': path.join(__dirname, '../../', configs.dirs.components),
    'stores': path.join(__dirname, '../../', configs.dirs.stores),
    'mixins': path.join(__dirname, '../../', configs.dirs.mixins),
    'utils': path.join(__dirname, '../../', configs.dirs.utils),

    // 模块
    'SP': 'utils/sp',
    'developConfig': path.join(__dirname, '../../', 'config.json')
};
