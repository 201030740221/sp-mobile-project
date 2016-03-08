###
# ExchangeToCart.
# @author remiel.
# @page Point
###
T = React.PropTypes
ExchangeToCart = React.createClass

    propTypes:
        data: T.object
        onTap: T.func

    getDefaultProps: ->
        data: {}
        onTap: () ->
            # console.log 'tap'

    getInitialState: ->
        showModal: no

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

    onTap: (e) ->
        data = @props.data
        A('checkout').exchange(data.sku_id) # .always (res) ->
            # console.log res
        #     @onModalShow()
        # @props.onTap()

    goToCart: () ->
        @onModalHide()
        SP.redirect "/cart"

    renderContent: () ->
        <div className="exchange-success-modal u-text-center u-f14 u-pb-20 u-pt-30 u-color-black">
            <div className="u-mb-5">{@props.data.name}已经成功兑换</div>
            <div className="u-f18">
                消耗积分：
                <span className="u-color-gold">{@props.data.price}</span>
            </div>
        </div>

    renderModal: () ->
        <Modal name="confirm-modal" onCloseClick={@onModalHide} show={@state.showModal} margin={15}>
            {@renderContent()}
            <div className="u-text-center u-pb-20 u-flex-box">
                <div className="u-flex-item-1 u-pr-5 u-pl-15">
                    <Button onTap={@onModalHide} block bsStyle='primary'>继续兑换</Button>
                </div>
                <div className="u-flex-item-1 u-pl-5 u-pr-15">
                    <Button onTap={@goToCart} block bsStyle='primary'>现在去结算</Button>
                </div>
            </div>
        </Modal>

    render: ->
        <Tappable {...@props} onTap={@onTap}>
            {@props.children}
            {@renderModal()}
        </Tappable>
module.exports = ExchangeToCart
