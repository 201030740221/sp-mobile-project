'use strict';
//var url = require('url');

module.exports = function (grunt) {

    // 耗时
    require('time-grunt')(grunt);
    // 自加载
    require('load-grunt-tasks')(grunt);

    // 工程目录
    var config = {
        test: 'data'
    };

    // 任务
    grunt.initConfig({

        // 项目设置
        config: config,

        mock2easy: {
            test:{
                options: {
                    port:7010,
                    lazyLoadTime:3000,  // 延时加载时间
                    database:'<%= config.test %>/database',
                    doc:'<%= config.test %>/doc',
                    keepAlive:true,  // 是否独立运行
                    ignoreField:['__preventCache', 'secToken'],  // 默认忽略的接口入参
                    interfaceSuffix:'.json' //默认生成为 .json 结尾的接口
                    /*curl: {  // curl 这个参数如果配置了，就通过curl访问远程接口，不再访问本地接口
                        domain: 'http://www.sipin.com',  // 域名
                        parameter: {                           // 每次请求需要带的参数
                            secToken: 'jimZPPU1MZtLmjFXnxCl22'
                        },
                        Cookie: 'kRm9JWrHB9%2B%2Bq84dcf4tLAUfECcVq5NknX2Rs9ic'
                    }*/
                }
            }
        }

    });


    // 模拟数据服务
    grunt.registerTask('mock', ["mock2easy:test"]);

};
