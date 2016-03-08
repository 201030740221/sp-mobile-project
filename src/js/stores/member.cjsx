
store = liteFlux.store "member",
    data:
        id: null,
        name: "",
        analytics_user_key: '',
        user_key: '',
        nickname: null,
        email: "",
        mobile: "",
        realname: null,
        avatar: null,
        is_mobile_valid: null,
        is_email_valid: null,
        total_quantity: 0,
        orderStatistics: {}
    actions:
        # 更新用户名
        updateUserName: (newName)->
            newMemberState = this.getStore();
            newMemberState.name = newName;
            newMemberState.is_name_init = 0;
            this.setStore(newMemberState);
            SP.storage.set('member', JSON.stringify(newMemberState) );
        # 获得订单数目信息
        getOrderStatistics: ->
            self = this
            webapi.order.getOrderStatistics().then (res)->
                if(res && res.code == 0)
                    state = self.getStore()
                    state.orderStatistics = res.data
                    self.setStore state

        # 从线上获取最新的用户信息
        getMemberInformation: ->
            return new SP.promise (resolve, reject)->
                webapi.member.hello().then (res)->

                    if(res && res.code == 0)
                        resolve(res.data);
                    else
                        reject(false);
        # 获得并设置最新的用户数据
        setMemberInformation: ->
            liteFlux.action("member").getMemberInformation().then (res)->
                liteFlux.action("member").login(res)
        # 更新购物车数量
        setTotalQuantity: (val)->
            store = this.getStore();
            store.total_quantity = val;
            this.setStore(store);
            # 存于本地存储
            SP.storage.set('member', JSON.stringify(@getStore()) );
        # 是否登录
        islogin: ->
            if @getStore().id
                return true
            return false
        # 设置登录数据
        login: (res)->
            @reset()

            olddata = this.getStore()

            if(res.member)
                data =
                    analytics_user_key: res.member.analytics_user_key
                    user_key: res.member.user_key
                    avatar: res.member.avatar
                    email: res.member.email
                    id: res.member.name
                    is_email_valid: res.member.is_email_valid
                    is_mobile_valid: res.member.is_mobile_valid
                    is_name_init: res.member.is_name_init
                    location: res.location
                    mobile: res.member.mobile
                    name: res.member.name
                    nickname: res.member.nickname
                    realname: res.member.realname
                    token: res.token
                    total_quantity: res.total_quantity
                    orderStatistics: olddata.orderStatistics
                window._ozuid = res.analytics_user_key;
            else
                data =
                    analytics_user_key: ''
                    user_key: ''
                    location: res.location
                    token: res.token
                    total_quantity: res.total_quantity
                    id: null,
                    name: "",
                    nickname: null,
                    email: "",
                    mobile: "",
                    realname: null,
                    avatar: null,
                    is_mobile_valid: null,
                    is_email_valid: null,
                    orderStatistics: {}
                window._ozuid = '';


            @setStore(data);
            # 存于本地存储
            SP.storage.set('member', JSON.stringify(@getStore()) );
        # 从本地存储取用户信息
        getMemberFromLocalStore: ()->
            if(SP.storage.get('member')!=null)
                @setStore(JSON.parse(SP.storage.get('member')));
                return @getStore();
            return null;
        # 登出
        logout: (callback)->
            webapi.member.logout().then (res)->
                if(res && res.code ==0)
                    SP.storage.remove('member');
                    liteFlux.store("member").reset();
                    window._ozuid = '';
                    #SP.redirect('/member');
                    if(callback)
                        callback()

module.exports = store;
