###
# Invoice.
# @author remiel.
# @module Invoice
###

Store = appStores.invoice
Action = Store.getAction()
CheckoutStore = appStores.checkout
CheckoutAction = CheckoutStore.getAction()

T = React.PropTypes

InvoicEdit = React.createClass
    mixins: [MemberCheckLoginMixin, liteFlux.mixins.storeMixin('invoice')]
    propTypes:
        confirmText: T.string
        cancelText: T.string

    # 如果未登录
    _logoutCallback: ->
        SP.redirect('/member',true);

    getDefaultProps: ->
        confirmText: "确定"
        cancelText: "取消"


    onModalShow: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        Action.onModalShow()

    onModalHide: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        Action.onModalHide()

    confirm:() ->
        invoice = @state.invoice
        if invoice.title_type is 1 and Action.valid()
            @save()

        if invoice.title_type is 0
            @save()


    cancel:() ->
        Action.reset()

    onTap: (e) ->
        e.preventDefault()
        e.stopPropagation()
        @onModalShow()
        @props.onTap() if @props.onTap?

    onChangeType: (value) ->
        Action.onChange value, 'title_type'

    onChange: (type, value) ->
        Action.onChange value, type

    save: () ->
        Action.save()

    renderModal: ->
        # if @state.showModal is no
        #     return ""
        ndoe = ""
        error = @state.invoice.fieldError
        switch @state.invoice.title_type
            when 0
                node =
                    <div className="form-box has-border-bottom border-indent-left border-indent-right u-mb-20">
                        <header className="form-box-hd large-margin-top">
                            个人普通发票
                        </header>
                    </div>
            when 1
                company_name =
                    value: @state.invoice.company_name
                    requestChange: @onChange.bind null, 'company_name'
                node =
                    <div className="form">
                        <Panel>
                            <div>
                                <Input type="text" valueLink={company_name} placeholder="单位名称" />
                            </div>
                            <div className="form-error-info u-mt-10">{ if error and error.company_name then error.company_name[0] else ""}</div>
                        </Panel>
                    </div>
        classes =
            type0: SP.classSet
                "active": @state.invoice.title_type is 0
                "u-flex-item-1": yes
            type1: SP.classSet
                "active": @state.invoice.title_type is 1
                "u-flex-item-1": yes

        <Modal name="invoice-modal" title={@props.title || ""} onCloseClick={@cancel} show={@state.invoice.showModal} margin={30}>
            <div className="invoice-modal-hd u-text-center u-flex-box u-f14">
                <Tappable component="div" className={classes.type0} onTap={@onChangeType.bind null, 0}>
                    个人
                </Tappable>
                <Tappable component="div" className={classes.type1} onTap={@onChangeType.bind null, 1}>
                    单位
                </Tappable>
            </div>
            <div className="invoice-modal-bd u-mb-10 u-mt-10">
                {node}
            </div>
            <div className="u-text-center u-pb-10 u-flex-box">
                <div className="u-flex-item-1 u-pr-5 u-pl-15">
                    <Button onTap={@cancel} block bsStyle='primary'>{@props.cancelText}</Button>
                </div>
                <div className="u-flex-item-1 u-pl-5 u-pr-15">
                    <Button onTap={@confirm} block bsStyle='primary'>{@props.confirmText}</Button>
                </div>
            </div>
        </Modal>
    render: () ->
        <Tappable {...@props} onTap={@onTap}>
            {@props.children}
            {@renderModal()}
        </Tappable>



module.exports = InvoicEdit
