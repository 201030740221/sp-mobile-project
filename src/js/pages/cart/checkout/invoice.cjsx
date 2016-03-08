###
# Invoice
# @author remiel.
# @module Checkout
###
React = require 'react'

Invoice = React.createClass
    goToInvoice: (e) ->
        SP.redirect "/checkout/invoice"

    render: ->
        invoiceData = <span className="u-fr u-mr-30">{@props.data}</span> if @props.data

        <Tappable component="div" className="form-box checkout-nav has-border-bottom" onTap={@goToInvoice}>
            <header className="form-box-hd large-padding">
                索取发票
                {invoiceData}
                <Button bsStyle="icon" icon='arrowright' onTap={@goToInvoice} />
            </header>
        </Tappable>

module.exports = Invoice
