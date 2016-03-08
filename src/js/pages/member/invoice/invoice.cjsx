###
# Invoice.
# @author remiel.
# @module Invoice
###

Store = appStores.invoice
Action = Store.getAction()
CheckoutStore = appStores.checkout
CheckoutAction = CheckoutStore.getAction()

InvoiceEdit = require './invoice-edit'
PageInvoice = React.createClass
    mixins: [liteFlux.mixins.storeMixin('invoice')]
    getInitialState: ->
        Action.getInvoice()
        {}

    renderBar: () ->
        <Toolbar>
            <div className="invoice-bar u-text-center">
                <InvoiceEdit component={Button} large bsStyle='primary'>添加发票</InvoiceEdit>
            </div>
        </Toolbar>
    renderEmpty: () ->
        <Empty texts={['暂无发票','请点击下方按钮添加发票']} />

    updateInvoice: (item, e) ->
        e.stopPropagation()
        e.preventDefault()
        Action.setCurrent item, yes
    deleteInvoice: (item) ->
        Action.deleteInvoice item.id
        true

    setCheckoutInvoice: (item) ->
        if +S('checkout').invoice_id is item.id
            CheckoutAction.onChange '', 'invoice_id'
            CheckoutAction.onChange '', 'invoice_text'
        else
            text = ''
            if item.title_type is 0
                text = '个人'
            if item.title_type is 1
                text = item.company_name
            CheckoutAction.onChange item.id, 'invoice_id'
            CheckoutAction.onChange text, 'invoice_text'
        SP.redirect '/checkout'

    renderList: () ->
        list = @state.invoice.list
        if list isnt null and list.length
            list.map (item, i) =>
                content = if item.title_type is 1 then item.company_name else "个人普通发票"
                hdClass = SP.classSet
                    "large-margin-top": i is 0
                    "u-color-gold": item.id is CheckoutStore.getStore().invoice_id
                hdClass += " form-box-hd has-border-bottom border-dashed"
                <div className="form-box invoice-item u-mb-10" key={i}>
                    <Tappable component="header" className={hdClass} onTap={@setCheckoutInvoice.bind null, item}>
                        {content}
                    </Tappable>
                    <footer className="form-box-bd u-text-right">
                        <span className={"u-color-border"}>{"|"}</span>
                        <Tappable component="a" className={"address-item-btn u-text-right u-black-link"} onTap={@updateInvoice.bind null, item}>
                            修改
                        </Tappable>
                        <span className={"u-color-border"}>{"|"}</span>
                        <Confirmable component="a" className={" address-item-btn u-text-right u-black-link"} confirm={@deleteInvoice.bind null, item} content="确定删除该发票">
                            删除
                        </Confirmable>
                    </footer>
                </div>
        else
            ""

    render: ->
        <Page navbar-through toolbar-through className="member-invoice">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="索取发票"></Navbar>
            {@renderBar()}
            <PageContent>
                {@renderList()}
            </PageContent>
        </Page>


module.exports = PageInvoice
