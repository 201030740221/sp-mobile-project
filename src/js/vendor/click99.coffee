module.exports =
    loadjs: (callback)->
        # 配置99click
        stat9cjs=document.createElement("script");
        stat9cjs.src="//stat-9c.sipin.com/99click_mobile.js";
        s=document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(stat9cjs,s);
        stat9cjs.onload = callback
