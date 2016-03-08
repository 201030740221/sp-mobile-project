module.exports =
    #获得对象的key
    SKUResult: {},
    currentSku: [],
    getObjKeys: (obj) ->
        if (obj != Object(obj))
            throw new TypeError('Invalid object')
        keys = []
        for key of obj
            if Object::hasOwnProperty.call(obj, key)
                keys[keys.length] = key
        keys

    #把组合的key放入结果集SKUResult
    addToSKUResult: (combArrItem, sku) ->
        key = combArrItem.join(';')
        if @SKUResult[key]
            #SKU信息key属性·
            @SKUResult[key].skuSn = sku['skuSn']
            #SKUResult[key].count += sku.count
            @SKUResult[key].prices.push sku.price
        else
            @SKUResult[key] =
                skuSn: sku['skuSn']
                #count: sku.count
                prices: [sku.price]
                url: sku['url']
        return
    # 处理后台数据
    transformSkuData: (skuObj)->
        result = {}
        return false if !skuObj
        for sku in skuObj
            attr_item = []
            attributeKeyGroup = sku["attribute_key"].split(",")
            for attributeKeyGroup_item in attributeKeyGroup
                _attr_item = attributeKeyGroup_item.split("-")
                attr_item.push _attr_item[1]
            getKey = ()->
                # attr_item.join(";")
                attr_item.sort (a,b)->
                    return parseInt(a)-parseInt(b)
                return attr_item.join(";")
            result[getKey()] =
                price:sku.price
                skuSn:sku["sku_sn"]
                goods:sku["goods_id"]
                url: sku['url']
        result
    ###
    # 获得从m中取n的所有组合
    ###
    getFlagArrs: (m, n) ->
        if !n or n < 1
            return []
        resultArrs = []
        flagArr = []
        isEnd = false
        i = 0
        while i < m
            flagArr[i] = if i < n then 1 else 0
            i++
        resultArrs.push flagArr.concat()
        while !isEnd
            leftCnt = 0
            k = 0
            while k < m - 1
                if (flagArr[k] == 1) and (flagArr[k + 1] == 0)
                    j = 0
                    while j < k
                        flagArr[j] = if j < leftCnt then 1 else 0
                        j++
                    flagArr[k] = 0
                    flagArr[k + 1] = 1
                    aTmp = flagArr.concat()
                    resultArrs.push aTmp
                    if (aTmp.slice(-n).join('').indexOf('0') == -1)
                        isEnd = true
                    break
                (flagArr[k] == 1) and leftCnt++
                k++
        resultArrs
    ###
    # 从数组中生成指定长度的组合
    ###
    arrayCombine: (targetArr) ->
        if !targetArr or !targetArr.length
            return []
        len = targetArr.length
        resultArrs = []
        # 所有组合
        n = 1
        while n < len
            flagArrs = @getFlagArrs(len, n)
            while flagArrs.length
                flagArr = flagArrs.shift()
                combArr = []
                i = 0
                while i < len
                    flagArr[i] and combArr.push(targetArr[i])
                    i++
                resultArrs.push combArr
            n++
        resultArrs
    #初始化得到结果集
    initSKU : ->
        store = liteFlux.store(@skuStoreName).getStore()
        skuData = @transformSkuData store.skuPicker.optional
        skuKeys = @getObjKeys(skuData)
        i = 0
        while i < skuKeys.length
            skuKey = skuKeys[i]
            #一条SKU信息key
            sku = skuData[skuKey]
            #一条SKU信息value
            skuKeyAttrs = skuKey.split(';')
            #SKU信息key属性值数组
            len = skuKeyAttrs.length
            #对每个SKU信息key属性值进行拆分组合
            combArr = @arrayCombine(skuKeyAttrs)
            j = 0
            while j < combArr.length
                @addToSKUResult combArr[j], sku
                j++
            #结果集接放入SKUResult
            @SKUResult[skuKey] =
                #count: sku.count
                skuSn: sku['skuSn']
                prices: [sku.price]
                url: sku['url']
            i++
        return
    # 渲染规格
    renderSku: ->
        store = liteFlux.store(@skuStoreName).getStore()
        if not store.skuPicker
            return ''
        # 处理组合
        @initSKU()
        store.skuPicker.skuData.map (item, i)=>
            # 如果属性不为空
            if item.value.length
                @renderSkuItem item, i
    # 获得对应的 SKU 组合
    getSelectSku: ->
        selectedIds = []
        store = liteFlux.store(@skuStoreName).getStore()
        for key of store.skuPicker.attribute_key
            if store.skuPicker.attribute_key[key]
                selectedIds.push store.skuPicker.attribute_key[key]
        selectedIds.sort (value1, value2) ->
            parseInt(value1) - parseInt(value2)
        selectedIds.join(';')
    # 选择 SKU
    selectItem: (data,e)->
        action = liteFlux.store(@skuStoreName).getAction()
        if !(/choice-disabled/.test e.target.className)
            store = liteFlux.store(@skuStoreName).getStore()
            len = Object.keys(store.skuPicker.attribute_key).length
            if store.skuPicker.attribute_key[data.attribute_id] ==  data.id
                store.skuPicker.attribute_key[data.attribute_id] = null
            else
                store.skuPicker.attribute_key[data.attribute_id] = data.id
            # 保存 store
            liteFlux.store(@skuStoreName).setStore(store)
            if typeof action.setSelectedSku is 'function'
                action.setSelectedSku @SKUResult[@getSelectSku()]
            # 检查是否有相应的组合，且选中的组合长度是最长
            if !!(@SKUResult[@getSelectSku()] and @getSelectSku().split(";").length==len and @SKUResult[@getSelectSku()].skuSn)
                if sipinConfig.env == "production"
                    liteFlux.event.emit('click99',"click", "btn_sku_select")
                # SP.redirect '/item/'+ @SKUResult[@getSelectSku()].skuSn,true # 改变当前的路径显示
                #@props.setPath '/item/'+ @SKUResult[@getSelectSku()].skuSn # 改变当前的路径
    # 渲染规格子项
    renderChildItem: (data)->
        self = this
        store = liteFlux.store(@skuStoreName).getStore()
        data.map (child, i)->
            checked = false
            # 如果与 store 中选中的属性相同，则显示选中状态
            if store.skuPicker.attribute_key[child.attribute_id] ==  child.id
                checked = true

            # 默认为可点击
            disabled = true

            # 存放所有与相邻属性组合
            attrIds = []
            store.skuPicker.skuData.map (res)->
                # 如果属性值不为空且不是当前属性组
                if(res.value.length and res.id!=child.attribute_id)
                    res.value.map (val)->
                        # 获得当前属性与相邻属性两两组合
                        attrIds.push [child.id,val.id, val.check]

            # 对相邻属性进行分析
            if attrIds.length
                j = 0
                while j < attrIds.length
                    # 获得相邻属性值是否被选中的
                    otherCheck = attrIds[j].pop();
                    # 两两SKU信息key属性值进行拆分组合
                    attrId = self.arrayCombine(attrIds[j])
                    keys = attrId.sort (value1, value2) ->
                        parseInt(value1) - parseInt(value2)
                    key = keys.join(';')
                    # 判断当前属性是否被选中
                    if child.check == 1
                        disabled = false
                    # 判断组合是否存在且相邻属性值选中状态
                    else if self.SKUResult[key] and otherCheck ==1
                        disabled = false

                    j++
            else
                disabled = false

            <ChoiceCheckbox.Item key={i} disabled={disabled} status={checked} onClick={self.selectItem.bind null,child}>
                {child.attribute_value}
            </ChoiceCheckbox.Item>
    # 渲染每条规格
    renderSkuItem: (item, i)->
        store = liteFlux.store(@skuStoreName).getStore()
        if not store.skuPicker
            return ''
        #字符串中插入 &nbsp
        item_name = item.name
        return (
            <Grid key={item.id} cols={24} className="label-list" key={i}>
                <Col span={5} className="label-title">{item_name.substr(0,1)}&nbsp;&nbsp;&nbsp;&nbsp{item_name.substr(1,1)}:</Col>
                <Col span={19}>
                    <ChoiceCheckbox>
                        {this.renderChildItem(item.value)}
                    </ChoiceCheckbox>
                </Col>
            </Grid>
        )
