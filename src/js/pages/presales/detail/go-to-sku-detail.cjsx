React = require 'react'
storeName = 'presales-detail'
Store = require 'stores/presales-detail'
Action = Store.getAction()
View = React.createClass
    mixins: [liteFlux.mixins.storeMixin(storeName)]
    goToSkuDetail: () ->

        store = @state[storeName]
        skuPicker = store.skuPicker
        selected_sku = skuPicker.selected_sku
        sku_sn = selected_sku.sku_sn
        id = selected_sku.id
        SP.redirect '/item/' + sku_sn

    render: ->

        store = @state[storeName]
        skuPicker = store.skuPicker
        if skuPicker is null
            return ''
        <Toolbar>
            <div className="presales-bar u-text-center">
                <Button large bsStyle="red-yellow" onTap={@goToSkuDetail}>免预约直接购买</Button>
            </div>
        </Toolbar>

module.exports = View
