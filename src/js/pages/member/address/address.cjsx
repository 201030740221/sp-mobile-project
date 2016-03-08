###
# PageAddress.
# @author remiel.
# @module Checkout
###
React = require 'react'
Store = appStores.address
Action = Store.getAction()
NewAddressStore = appStores.newAddress
NewAddressAction = NewAddressStore.getAction()

T = React.PropTypes

PageAddress = React.createClass
    mixins: [MemberCheckLoginMixin, liteFlux.mixins.storeMixin('address')]

    # 如果未登录
    _logoutCallback: ->
        SP.redirect('/member',true);

    componentDidMount: ->
        Action.getAddress()

    AddressManage: () ->
        SP.redirect "/member/address"

    AddressCreate: () ->
        switch @props.type
            when 'checkout'
                SP.redirect "/checkout/address/create"
            when 'exchange'
                SP.redirect "/exchange/address/create"
            when 'profile'
                SP.redirect "/member/address/create"



    setCheckoutAddress: (item) ->
        Action.setCheckoutAddress(item, @props.type)

    setDefaultAddress: (item) ->
        Action.setDefaultAddress(item)

    deleteAddress: (item) ->
        Action.deleteAddress(item.id)
        true

    updateAddress: (item, e) ->
        e.stopPropagation()
        e.preventDefault()
        NewAddressAction.setCurrent item
        SP.redirect "/member/address/edit"



    renderBar: () ->
        node = ''
        switch @props.type
            when 'checkout'
                node =
                    <Toolbar>
                        <div className="checkout-address-bar u-flex-box">
                            <div className="u-flex-item-1 u-pr-5">
                                <Button block bsStyle='primary' onTap={@AddressCreate}>使用新地址</Button>
                            </div>
                            <div className="u-flex-item-1 u-pl-5">
                                <Button block bsStyle='primary' onTap={@AddressManage}>管理地址</Button>
                            </div>
                        </div>
                    </Toolbar>
            when 'exchange'
                node =
                    <Toolbar>
                        <div className="checkout-address-bar u-flex-box">
                            <div className="u-flex-item-1 u-pr-5">
                                <Button block bsStyle='primary' onTap={@AddressCreate}>使用新地址</Button>
                            </div>
                            <div className="u-flex-item-1 u-pl-5">
                                <Button block bsStyle='primary' onTap={@AddressManage}>管理地址</Button>
                            </div>
                        </div>
                    </Toolbar>
            when 'profile'
                node =
                    <Toolbar>
                        <div className="checkout-address-bar u-flex-box u-text-center">
                            <div className="u-flex-item-1 u-pr-5">
                                <Button large bsStyle='primary' onTap={@AddressCreate}>添加新地址</Button>
                            </div>
                        </div>
                    </Toolbar>

        node

    checkoutAddress: () ->
        address = @state.address
        data = address.list || []

        checkout = S("checkout")
        if checkout?
            activeAddress = checkout.address

        data.map (item, i) =>
            classes = SP.classSet
                "address-item": yes
                "active" : if activeAddress and activeAddress isnt null then activeAddress.id is item.id else item.is_default is 1

            <Tappable component="div" className={classes} key={i} onTap={@setCheckoutAddress.bind(null, item)}>
                <div>
                    <span>{item.consignee}</span>{" "}
                    <span>{item.mobile}</span>
                </div>
                <div>
                    {item.province_name}{" "}{item.city_name}{" "}{item.district_name}{" "}{item.address}
                </div>
            </Tappable>


    profileAddress: () ->
        address = @state.address
        data = address.list || []
        data.map (item, i) =>

            classes =
                wrapper: SP.classSet "form-box has-border-bottom border-dashed u-pb-15", {
                    "address-item": yes
                    "active" : item.is_default is 1
                }
                btn: SP.classSet
                    "u-none" : item.is_default is 1
            <div className="address-item-box u-mb-10" key={i}>
                <div className={classes.wrapper}>
                    <div>
                        <span>{item.consignee}</span>{" "}
                        <span>{item.mobile}</span>
                    </div>
                    <div>
                        {item.province_name}{" "}{item.city_name}{" "}{item.district_name}{" "}{item.address}
                    </div>
                </div>
                <footer>
                    <Tappable component="a" className={classes.btn + " address-item-btn u-text-right u-black-link"} onTap={@setDefaultAddress.bind(null, item)}>
                        设为默认收货地址
                    </Tappable>
                    <span className={" u-color-border"}>{"|"}</span>
                    <Tappable component="a" className={"address-item-btn u-text-right u-black-link"} onTap={@updateAddress.bind(null, item)}>
                        修改
                    </Tappable>
                    <span className={classes.btn + " u-color-border"}>{"|"}</span>
                    <Confirmable component="a" className={classes.btn + " address-item-btn u-text-right u-black-link"} confirm={@deleteAddress.bind(null, item)} content="确定删除该地址">
                        删除
                    </Confirmable>
                </footer>
            </div>




    renderList: () ->
        switch @props.type
            when 'checkout'
                @checkoutAddress()
            when 'exchange'
                @checkoutAddress()
            when 'profile'
                @profileAddress()

    render: ->
        type = @props.type
        classes =
            pageContent: SP.classSet
                "bg-white": type is "checkout" or type is "exchange"
            addressList: SP.classSet
                "address-list": type is "checkout" or type is "exchange"
                "address-list-profile": type is "profile"


        title = ''
        switch @props.type
            when 'checkout'
                title = "选择地址"
            when 'exchange'
                title = "选择地址"
            when 'profile'
                title = "管理地址"

        <Page navbar-through toolbar-through className="cart-checkout cart-checkout-address member-profile-address">
            <Navbar leftNavbar={<BackButton />} title={title}></Navbar>
            {@renderBar()}
            <PageContent className={classes.pageContent}>
                <div className={classes.addressList}>
                    {@renderList()}
                </div>
            </PageContent>
        </Page>

module.exports = PageAddress
