###
# 简单的ajax的实现
###
Promise = require 'yaku'

serialize = (obj)->
    params = [];
    for p of obj
        if obj.hasOwnProperty(p)
            if obj[p] instanceof Array
                for i in data[p]
                    params.push encodeURIComponent(p) + '[]=' + encodeURIComponent(obj[p][i])
            else
                params.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]))
    return params.join('&').replace(/%20/g, '+')

request = (opts)->

    return new Promise (resolve, reject)->

        fn = ()->

        settings = {
            method: opts.method || 'GET'
            data: opts.data || null
            success: opts.success || fn
            fail: opts.fail || fn
            async: opts.async || true
            beforeSend: opts.beforeSend || fn
            url: opts.url || ''
        }

        xhr = if window.XMLHttpRequest then new XMLHttpRequest() else new ActiveXObject('Microsoft.XMLHTTP')

        xhr.onreadystatechange = ()->
            if xhr.readyState == 4
                if String(xhr.status).match(/^2\d\d$/)
                    settings.success JSON.parse xhr.responseText
                    resolve JSON.parse xhr.responseText
                else
                    settings.fail xhr
                    reject xhr

        if(settings.data)
            settings.url = settings.url + '?' + serialize(settings.data)

        xhr.open settings.method,settings.url,settings.async

        if settings.method=="POST"
            xhr.setRequestHeader 'Content-type', 'application/x-www-form-urlencoded;'


        xhr.send settings.data


module.exports = request;
