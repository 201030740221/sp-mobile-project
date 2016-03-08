module.exports =
    loadjs: (callback)->
        # 配置Meiqia
        kfjs=document.createElement("script");
        kfjs.setAttribute('charset','UTF-8');
        kfjs.setAttribute('async','async');
        kfjs.src="//meiqia.com/js/mechat.js?unitid=55a773f34eae352940000005&btn=hide";
        s=document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(kfjs,s);
        kfjs.onload = callback
