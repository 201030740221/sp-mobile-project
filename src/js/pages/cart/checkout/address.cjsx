###
# Address.
# @author remiel.
# @module Checkout
###

Address = React.createClass

    goToAddressList: () ->
        SP.redirect '/' + @props.type + '/address'
    goToNewAddress: () ->
        SP.redirect '/' + @props.type + '/address/create'

    renderItem: () ->
        item = @props.data
        if item?
            <Tappable component="div" className="form-box-bd u-color-gray-summary" onTap={@goToAddressList}>
                <div className="u-pr">
                    <div>
                        <span>{item.consignee}</span>{" "}
                        <span>{item.mobile}</span>
                    </div>
                    <div>
                        {item.province_name}{" "}{item.city_name}{" "}{item.district_name}{" "}{item.address}
                    </div>
                    <Button bsStyle="icon" icon='arrowright' />
                </div>
            </Tappable>
        else
            ""

    render: ->
        item = @props.data
        classes =
            btn: SP.classSet
                "u-none": item?
            box: SP.classSet "form-box has-border-bottom border-dashed border-indent-left border-indent-right checkout-address", @props.className
        <div className={classes.box}>
            <header className="form-box-hd large-margin-top">
                收货信息
                <Button bsStyle="icon" icon='more' className={classes.btn} onTap={@goToNewAddress} />
            </header>
            {@renderItem()}
        </div>

module.exports = Address
