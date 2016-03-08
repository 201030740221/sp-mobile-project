React = require 'react'
storeName = 'presales-detail'
Store = require 'stores/presales-detail'
Action = Store.getAction()
goodsSkuSelector = require './goods-sku-selector'
RegionBar = require './region-bar'
View = React.createClass
    skuStoreName: storeName
    mixins: [liteFlux.mixins.storeMixin(storeName), goodsSkuSelector]
    getDefaultProps: ->
        confirmText: "我知道了"
        content: "确认?"
        margin: 30
        showCloseIcon: no
        showConfirmBtn: yes
        maskClose: no

    getInitialState: ->
        showModal: false
    onModalShow: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        @setState
            showModal: yes
    onModalHide: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        @setState
            showModal: no

    cancel:() ->
        @onModalHide()


    onTap: (e) ->
        e.preventDefault()
        e.stopPropagation()
        @onModalShow()
        @props.onTap() if @props.onTap?
    getDelivery: () ->
        # console.log 'getDelivery'
        Action.getDelivery()

    renderModal: ->
        store = @state[storeName]
        skuPicker = store.skuPicker
        sku = skuPicker.selected_sku
        batches = store.batches
        presale_price = ''
        earnest_money = ''
        batches.skus.map (item, i) =>
            if item.goods_sku_id is sku.id
                presale_price = item.presale_price
                earnest_money = item.earnest_money


        # <div className="grid label-list">
        #     <div className="col-5-24 label-title"></div>
        #     <div className="col-18-24 u-color-black">
        #         <span className="u-color-gray-summary">物流费: </span>
        #         ￥{skuPicker.delivery || '0.00'}
        #         <span className="u-color-gray-summary u-ml-15">安装费: </span>
        #         ￥{sku.installation || '0.00'}
        #     </div>
        # </div>
        <Modal name="presales-sku-modal" title={""} onCloseClick={@cancel} show={@state.showModal} margin={0} showCloseIcon={no} maskClose={yes} position={'bottom'}>
            <div className="presales-sku-modal-hd">
                <div className="presales-sku-modal-hd-img">
                    <Img src={sku.has_cover.media.full_path} w={148}/>
                </div>
                <section>
                    <h3>{sku.goods.title}</h3>
                    <div>
                        <span className="u-mr-10 u-color-red">预售价:￥{presale_price}</span>
                        <span className="u-del u-color-gray-summary">市场价:￥{sku.basic_price}</span>
                    </div>
                </section>
            </div>
            <div className="presales-sku-modal-content">
                <RegionBar getDelivery={@getDelivery} sku_sn={sku.sku_sn} />
                <br />
                {@renderSku()}
            </div>
            <div className="presales-bar u-text-center u-pb-5">
                <Button large bsStyle="red-yellow" onTap={@goToCheckout}>定金￥{earnest_money}，抢先预订</Button>
            </div>
        </Modal>
    goToCheckout: () ->
        Action.checkout()

    render: ->

        store = @state[storeName]
        current = store.current
        if current is null
            return ''
        skuPicker = store.skuPicker
        sku = skuPicker.selected_sku
        batches = store.batches
        presale_price = ''
        earnest_money = ''
        # batches.map (_item, i) =>
        #     # 找到当前批次
        #     if _item.id is current.next_valid_batch_id
        #         _item.skus.map (item, i) =>
        #             if item.goods_sku_id is sku.id
        #                 presale_price = item.presale_price
        #                 earnest_money = item.earnest_money

        batches.skus.map (item, i) =>
            if item.goods_sku_id is sku.id
                presale_price = item.presale_price
                earnest_money = item.earnest_money
        <Toolbar>
            <div className="presales-bar u-text-center">
                <Tappable component={Button} large bsStyle="red-yellow" onTap={@onTap} >
                    定金￥{earnest_money}，抢先预订
                    {@renderModal()}
                </Tappable>
            </div>
        </Toolbar>


module.exports = View
