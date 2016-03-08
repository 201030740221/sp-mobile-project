AddressStore = appStores.address
AddressAction = AddressStore.getAction()
Address = require 'pages/cart/checkout/address'
PageView = React.createClass
    mixins:[MemberCheckLoginMixin,liteFlux.mixins.storeMixin('address')],
    # 如果未登录
    _logoutCallback: ->
        SP.redirect('/member',true);

    getInitialState: ->
        {}

    componentDidMount: ->
        # 获得地址信息
        AddressAction.getAddress()
        # 获取最新的用户信息
        # if(!A("member").islogin())
        A("member").getMemberInformation().then (res)->
            A("member").login(res)

    render: ->
        memberStore = S("member")
        # 用户名是否可修改
        username = ->
            title = '用\u00A0\u00A0户\u00A0\u00A0名:'
            if(memberStore.is_name_init)
                return (
                    <ListView.Item href="/member/profile/username" title={title} value={memberStore.name} tips="只允许修改一次" />
                )
            else
                return (
                    <ListView.Item title={title} value={memberStore.name} />
                )


        # 手机修改
        mobile = ->
            title = '手\u00A0\u00A0机\u00A0\u00A0号:'
            if(memberStore.mobile)
                return (
                    <ListView.Item href="/member/profile/mobile/verify-mobile" title={title}  tips={""} value={memberStore.mobile} />
                )
            else
                return (
                    <ListView.Item href="/member/profile/mobile/bind" title={title}  tips={"未设置"} value={memberStore.mobile} />
                )


        # 真实姓名
        realname = ->
            tips = '未设置';
            if(memberStore.realname)
                tips = '';

            return (
                <ListView.Item href="/member/profile/realname" title="真实姓名:"  tips={tips} value={memberStore.realname} />
            );

        # Address
        address = =>
            list = @state.address.list
            node = ""
            goToNewAddres = () ->
                SP.redirect '/member/address/create'
            titleIcon = <Button bsStyle="icon" icon='more' onTap={goToNewAddres}/>
            if list isnt null and list.length
                list.map (item) =>
                    if item.is_default is 1
                        node =
                            <ListView className="u-mt-10" title={"收货信息"} titleRightIcon={titleIcon} label-gray>
                                <Link className="member-profile-take-delivery" href="/member/address">
                                    <div className="member-profile-take-delivery-inner">
                                        <div className="name">{item.consignee}{" "}{item.mobile}</div>
                                        <div className="address">{item.province_name}{" "}{item.city_name}{" "}{item.district_name}{" "}{item.address}</div>
                                    </div>
                                </Link>
                            </ListView>
            else
                node =
                    <ListView className="u-mt-10" title={"收货信息"} label-gray >
                        <ListView.Item title="收货地址：" tips="未设置"  href="/member/address/create" />
                    </ListView>

            node

        # 列表标题 - 基本信息
        return (
            <Page navbar-through >
                <Navbar leftNavbar={<BackButton />} title="我的信息" />
                <PageContent>
                    <ListView title={"基本信息"} label-gray>
                        {username()}
                        {mobile()}
                    </ListView>
                    <ListView className="u-mt-10" title={"安全信息"} label-gray>
                        <ListView.Item href="/member/profile/password/change" title="登录密码:" value="**********" />
                    </ListView>
                    {address()}
                </PageContent>
            </Page>
        );

module.exports = PageView;
