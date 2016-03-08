store = liteFlux.store "activity-july",
    data:
        data: null

    actions:
        getActivityData: () ->
            self = this;
            data = {
                page: "m_activity_july"
            }
            webapi.activity.getPageFrame(data).then (res)->
                if res && res.code == 0

                    singleData = []
                    off70 = []
                    off80 = []
                    off90 = []
                    secKillData = []
                    bottomData = []

                    res.data.point[0].recommendation.map (item)->
                        singleData.push {
                            id: item.id,
                            sku_sn: item.goods_sku.sku_sn
                            sku_id: item.goods_sku.id
                            title: item.goods_sku.goods.title,
                            desc: item.goods_sku.goods.subtitle,
                            img: (item.attachment && item.attachment.media.full_path) || (item.goods_sku && item.goods_sku.has_cover && item.goods_sku.has_cover.media.full_path),
                            price: item.goods_sku.goods_sku_price.price,
                            basic_price: item.goods_sku.goods_sku_price.basic_price,
                            point: item.extend_data.point,
                            stock: item.extend_data.stock
                        }

                    res.data.flash_sale_1yuan[0].recommendation.map (item)->
                        secKillData.push {
                            id: item.id,
                            sku_sn: item.goods_sku.sku_sn
                            sku_id: item.goods_sku.id
                            title: item.goods_sku.goods.title,
                            desc: item.goods_sku.goods.subtitle,
                            img: (item.attachment && item.attachment.media.full_path) || (item.goods_sku && item.goods_sku.has_cover && item.goods_sku.has_cover.media.full_path),
                            basic_price: item.goods_sku.goods_sku_price.price,
                            price: item.extend_data.price
                            start_time: item.extend_data.begin_at
                            end_time: item.extend_data.end_at
                        }

                    res.data.flash_sale_70off[0].recommendation.map (item)->
                        off70.push  {
                            id: item.id,
                            sku_sn: item.goods_sku.sku_sn
                            sku_id: item.goods_sku.id
                            title: item.goods_sku.goods.title,
                            desc: item.goods_sku.goods.subtitle,
                            img: (item.attachment && item.attachment.media.full_path) || (item.goods_sku && item.goods_sku.has_cover && item.goods_sku.has_cover.media.full_path),
                            basic_price: item.goods_sku.goods_sku_price.price,
                            price: item.extend_data.price
                            start_time: item.extend_data.begin_at
                            end_time: item.extend_data.end_at
                        }

                    res.data.flash_sale_80off[0].recommendation.map (item)->
                        off80.push  {
                            id: item.id,
                            sku_sn: item.goods_sku.sku_sn
                            sku_id: item.goods_sku.id
                            title: item.goods_sku.goods.title,
                            desc: item.goods_sku.goods.subtitle,
                            img: (item.attachment && item.attachment.media.full_path) || (item.goods_sku && item.goods_sku.has_cover && item.goods_sku.has_cover.media.full_path),
                            basic_price: item.goods_sku.goods_sku_price.price,
                            price: item.extend_data.price
                            start_time: item.extend_data.begin_at
                            end_time: item.extend_data.end_at
                        }

                    res.data.flash_sale_90off[0].recommendation.map (item)->
                        off90.push {
                            id: item.id,
                            sku_sn: item.goods_sku.sku_sn
                            sku_id: item.goods_sku.id
                            title: item.goods_sku.goods.title,
                            desc: item.goods_sku.goods.subtitle,
                            img: (item.attachment && item.attachment.media.full_path) || (item.goods_sku && item.goods_sku.has_cover && item.goods_sku.has_cover.media.full_path),
                            basic_price: item.goods_sku.goods_sku_price.price,
                            price: item.extend_data.price
                            start_time: item.extend_data.begin_at
                            end_time: item.extend_data.end_at
                        }

                    j = 0
                    res.data.bottom[0].recommendation.map (item,i)->
                        if i==2 || i==4 || i==6
                            j++
                        bottomData[j] = bottomData[j] || []
                        bottomData[j].push {
                            id: item.id,
                            title: item.goods_sku.goods.title,
                            desc: item.goods_sku.goods.subtitle,
                            img: (item.attachment && item.attachment.media.full_path) || (item.goods_sku && item.goods_sku.has_cover && item.goods_sku.has_cover.media.full_path),
                            basic_price: item.goods_sku.goods_sku_price.basic_price,
                            price: item.goods_sku.goods_sku_price.price
                            sku_sn: item.goods_sku.sku_sn
                            sku_id: item.goods_sku.id
                        }


                    # Object.keys(res.data.bottom[0].recommendation).map (item)->
                    #     bottomData.push {
                    #         title: item.goods_sku.goods.title,
                    #         desc: item.goods_sku.goods.subtitle,
                    #         img: (item.attachment && item.attachment.media.full_path) || (item.goods_sku && item.goods_sku.has_cover && item.goods_sku.has_cover.media.full_path),
                    #         num: "100",
                    #         basic_price: item.goods_sku.goods_sku_price
                    #     }

                    self.setStore
                        data:
                            singleData: singleData
                            off70: off70
                            off80: off80
                            off90: off90
                            secKillData: secKillData
                            bottomData: bottomData


module.exports = store;
