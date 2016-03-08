# debug 开关
if(location.hash.indexOf('?')!=-1)
    searchVar = location.hash.split('?')
    searchVar = searchVar[1]
    searchVarArr = searchVar.split('&')
    searchObj = {}
    for searchVarArr_i in searchVarArr
        tmp = searchVarArr_i.split("=")
        searchObj[tmp[0]]=tmp[1]

if typeof searchObj != 'undefined'
    if typeof searchObj['debug'] != 'undefined' and parseInt(searchObj['debug'])==1
        debug = true
else
    debug = false

module.exports = {
    debug: debug
};
