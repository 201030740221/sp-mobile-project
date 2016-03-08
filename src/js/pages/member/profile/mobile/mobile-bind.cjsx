pageStore = 'member-mobile';
# 限定重发时间
endTime = 120
timer = null

PageView = React.createClass
    mixins: [liteFlux.mixins.storeMixin(pageStore),LinkedStateMixin,ModulesMixins.memberMoblieMixin],
    getStateFromStore: ->
        return S(pageStore)
    setStateFromStore: ->
        if this.isMounted()
            this.setState S(pageStore)
    componentDidMount: ->
        clearInterval(timer);
        liteFlux.store(pageStore).reset();
        memberStore = S("member");
        switch @props.type
            # 修改密码
            #when "reset-pass"
            #    @state.account = memberStore.mobile
            # 验证已有的手机
            when "verify-mobile"
                @state.account = memberStore.mobile
            # 重置手机
            when "reset-mobile"
                SP.log "重置手机"
                # 需要判断是否从验证手机页面过来的
        S(pageStore,@state);
    componentWillReceiveProps: ->
        memberStore = S("member");
        switch @props.type
            # 修改密码
            #when "reset-pass"
            #    @state.account = memberStore.mobile
            # 验证已有的手机
            when "verify-mobile"
                @state.account = memberStore.mobile
            # 重置手机
            when "reset-mobile"
                SP.log "重置手机"
                # 需要判断是否从验证手机页面过来的
        S(pageStore,@state);

    componentWillUnmount: ->
        liteFlux.store(pageStore).reset();
        #liteFlux.store("member-mobile-temp").reset()
        clearInterval(timer);
    setTime: ->
        self = this;
        clearInterval(timer);
        timer = setInterval ->
            state = S(pageStore)
            if(state.time>0)
                S pageStore,
                    time: state.time-1
                    codeBtnText: (state.time-1) + '秒后重新获取'
            else
                clearInterval(timer);
                S pageStore,
                    time: endTime
                    codeBtnText: '重新获取验证码'
        ,1000

    _sendSms: ->
        self = this
        state = this.state
        smsApiName = 'sendSms2'

        if SP.isLogin()
            smsApiName = 'sendAuthSms'

        switch @props.type
            # 绑定新手机
            when "bind"
                type = 2
            # 验证已有的手机
            when "verify-mobile"
                type = 5
            # 重置手机
            when "reset-mobile"
                type = 5 # old is 2
            # 找回密码
            when "forgot"
                type = 4

        data = {
            type: type,
            mobile: state.account
        }

        data['captcha'] = @state.pictureCode;

        #发送手机验证码
        if !@issend
            self.issend = true
            webapi.member[smsApiName](data).then (res)->
                if(res && res.code ==0)
                    # TODO: 弹个提示，验证码已发送
                    SP.message
                        msg: "验证码已经下发到您的手机，请注意查收!"
                        callback: ->
                            self.issend = false
                    # 设置倒计时
                    if(state.time==endTime)
                        self.setTime()
                else
                    state.codeError = res.msg
                    S(pageStore,state)
                    self.issend = false

    startSendSms: ->

        self = this;

        # 检查手机是否存在
        webapi.member.checkMobile({
            mobile: this.state.account
        }).then (res)->
            SP.requestProxy(res).then (result)=>
                #如果帐号已存在
                state = self.state;
                switch self.props.type
                    # 绑定新手机
                    when "bind"
                        state.accountError = "该账号已经存在";
                    # 验证手机
                    when "verify-mobile"
                        self._sendSms();
                    # 修改密码
                    #when "reset-pass"
                    #    self._sendSms();
                    # 重置手机
                    when "reset-mobile"
                        state.accountError = "该账号已经存在";
                    # 找回密码
                    when "forgot"
                        self._sendSms();
                # 保存状态
                S(pageStore,state);
            .catch (result)->
                state = self.state;
                if result.code == 1
                    switch self.props.type
                        # 绑定新手机
                        when "bind"
                            self._sendSms();
                        # 验证手机
                        when "verify-mobile"
                            state.accountError = "该账号不存在，请检查后重试";
                        # 修改密码
                        #when "reset-pass"
                        #    state.accountError = "该账号不存在，请检查后重试";
                        # 重置手机
                        when "reset-mobile"
                            self._sendSms();
                        # 找回密码
                        when "forgot"
                            state.accountError = "该账号不存在，请检查后重试";
                    # 保存状态
                    S(pageStore,state);


    sendSms: (e)->

        e.preventDefault()
        e.stopPropagation()

        self = this;
        state = this.state;
        state.accountError = ""
        state.pictureCodeError = ""
        S(pageStore,state);

        # 正则验证手机
        if(A(pageStore).validatorData().valid('account') && state.time==endTime)

            # 如果启用图形验证码
            if(A(pageStore).validatorData().valid('pictureCode'))
                # 验证图形验证码是否正确
                webapi.member.checkCaptcha({
                    captcha: state.pictureCode
                }).then ->
                    self.startSendSms()
                .catch ->
                    state.pictureCodeError = '图形验证码错误，请重新尝试'
                    S(pageStore,state);
            #self.startSendSms()



    issend: false

    submitCode: ->
        self = this
        state = this.state
        state.emailError = ""
        state.pictureCodeError = ""
        state.accountError = ""
        S(pageStore,this.state)
        switch @props.type
            # 找回密码
            when "forgot"
                if(@state.forgotSwitchText == "通过邮箱找回密码") and !@issend
                    self.issend = true
                    if !this.getSubmitStatus() && A(pageStore).validatorData().valid("email")
                        state = this.state;
                        webapi.member.checkEmail({
                            email: state.email
                        }).then (res)->
                            if res && res.code == 0
                                webapi.member.sendMailWithAccount({
                                    account: state.email,
                                    type: 3
                                }).then (res)->
                                    if res && res.code == 0
                                        SP.message
                                            msg: "请接收邮件重置密码，并重新登录"
                                            callback: ->
                                                #跳转回用户信息页面
                                                SP.redirect('/member/login');
                                                self.issend = false;
                                    else
                                        SP.message
                                            msg: "发送重置密码邮件失败"
                                            callback: ->
                                                self.issend = false;
                            else
                                SP.message
                                    msg: "该账号不存在，请检查后重试"
                                    callback: ->
                                        self.issend = false
                else # 使用手机验证
                    if !this.getSubmitStatus() && A(pageStore).validatorData().valid("account") && A(pageStore).validatorData().valid("code")
                        webapi.member.checkSms({
                            mobile: state.account,
                            sms_code: state.code,
                            type: 4
                        }).then (res)->
                            state = self.state;
                            if res && res.code == 0
                                clearInterval(timer)
                                S('member-mobile-temp',{
                                    account: state.account
                                    sms_code: state.code
                                })
                                SP.redirect('/member/profile/password/reset')
                             else
                                SP.message
                                    msg: res.msg
                                    callback:->
                                        state.submitText="下一步";
                                        S(pageStore,state);
            # 其它
            else

                if !this.getSubmitStatus() && A(pageStore).validatorData().valid("account") && A(pageStore).validatorData().valid("code")
                    state = this.state;
                    state.submitText="正在检验验证码...";
                    S(pageStore,state);

                    switch self.props.type
                        # 绑定新手机
                        when "bind"
                            webapi.member.changeMobile({
                                mobile: S('member-mobile-temp').account,
                                sms_code: S('member-mobile-temp').code
                            }).then (res)->
                                state = self.state;
                                if res && res.code == 0
                                    #获取新的用户信息
                                    clearInterval(timer);
                                    liteFlux.store("member-mobile-temp").reset()
                                    A("member").getMemberInformation().then (res)->
                                        A("member").login(res.data)
                                    SP.message
                                        msg: "绑定新手机成功"
                                        callback: ->
                                            #跳转回用户信息页面
                                            SP.redirect('/member/profile');
                                else
                                    SP.message
                                        msg: res.msg
                                        callback:->
                                            state.submitText="下一步";
                                            S(pageStore,state);

                        # 验证手机
                        when "verify-mobile"
                            webapi.member.checkSms({
                                mobile: state.account,
                                sms_code: state.code,
                                type: 5
                            }).then (res)->
                                state = self.state;
                                if res && res.code == 0
                                    clearInterval(timer)
                                    liteFlux.store(pageStore).reset()
                                    SP.redirect('/member/profile/mobile/reset-mobile')
                                else
                                    SP.message
                                        msg: "验证码不正确"
                                        callback:->
                                            state.submitText="下一步";
                                            S(pageStore,state);
                        # 重置手机
                        when "reset-mobile"
                            webapi.member.changeMobile({
                                mobile: state.account,
                                sms_code: state.code
                            }).then (res)->
                                state = self.state;
                                if res && res.code == 0
                                    clearInterval(timer);
                                    liteFlux.store("member-mobile-temp").reset()
                                    SP.message
                                        msg: "绑定新手机成功"
                                        callback: ->
                                            SP.redirect('/member/profile');
                                else
                                    SP.message
                                        msg: res.msg
                                        callback:->
                                            state.submitText="下一步";
                                            S(pageStore,state);

                else
                    if !this.getSubmitStatus()
                        SP.message
                            msg: "验证码有误，请检查后重试"
    jumpLogin: ->
        SP.redirect('/member/login');

    getSubmitStatus: ->
        state = this.state;
        # 帐号、密码不为空，且没有错误信息
        if @props.type=="forgot" and state.forgotSwitchText == "通过邮箱找回密码"
            return !state.email.length
        else
            return !(state.account.length==11 && !state.accountError.length) || !(state.code.length==6 && !state.codeError.length) || state.submitText=="正在检验验证码...";

    getCaptcha: ->
        document.getElementById('captcha').src = apihost+'/captcha?' + Math.random();

    # 绑定手机
    onBindMobile: ->
        SP.redirect('/member/profile/mobile/bind')
    onModalHide: ->
        state = @state;
        state.showHandle = false;
        S(pageStore,state);
    # 找回密码时，切换手机或者邮箱
    onSwitchAccount: ->
        state = @state;
        state.showHandle = true;
        S(pageStore,state);
    onSwitchPhone:->
        state = @state;
        state.showHandle = false;
        state.forgotSwitchText = "通过手机找回密码";
        S(pageStore,state);
    onSwitchEmail:->
        state = @state;
        state.showHandle = false;
        state.forgotSwitchText = "通过邮箱找回密码";
        state.accountText = "邮箱地址";
        S(pageStore,state);
    onChangeSmsCode: ->
        S pageStore,
            code: this.refs.sms.getValue()
    onChangeAccount: ->
        S pageStore,
            account: this.refs.account.getValue()
    # 渲染弹框
    renderModal: ->
        return (
            <Modal name="orderHanderModal" onCloseClick={@onModalHide} show={@state.showHandle}>
                <div className="orderHanderButtons">
                    <Button bsStyle='primary' onTap={@onSwitchPhone} block >通过手机找回密码</Button>
                    <Button bsStyle='primary' onTap={@onSwitchEmail} block >通过邮箱找回密码</Button>
                </div>
            </Modal>
        );
    # 渲染邮箱界面
    renderEmail: ->
        btn = <Button bsStyle='primary' large className="u-mt-10" onTap={@onBindMobile}>马上绑定手机</Button>
        texts = [
            "抱歉，目前暂不开放移动端邮箱修改密码"
            "请登录PC端或绑定手机后进行修改"
        ]

        return (
            <Page navbar-through className="member-mobile">
                <Navbar leftNavbar={<BackButton />} title="修改密码" />
                <PageContent className="bg-white">
                    <Filter />
                    <Empty btn={btn} texts={texts}/>
                </PageContent>
            </Page>
        )

    renderMobile: ->
        memberStore = S("member")
        state = S(pageStore)
        showMobileClass =
            'u-none': @state.forgotSwitchText != "通过手机找回密码"

        showEmailClass =
            'u-none': @state.forgotSwitchText != "通过邮箱找回密码"

        # 如果是已绑定手机的，不需要出现这个页面
        accountPanel = (
            <Panel className={SP.classSet(showMobileClass)}>
                <div className="register-input">
                    <Input type="text" ref='account' onChange={this.onChangeAccount} value={state.account} placeholder="手机号" />
                </div>
                <div className="form-error-info u-mt-10">{state.fieldError && state.fieldError.account && state.fieldError.account[0]}{state.accountError}</div>
            </Panel>
        )

        switch @props.type
            #找回密码
            when "forgot"
                title = "找回密码"
            # 绑定新手机
            when "bind"
                title = "绑定手机号"
            # 修改密码
            # when "reset-pass"
            #     title = "验证手机号"
            #     isValid = ->
            #         if(memberStore.mobile)
            #             if(memberStore.is_mobile_valid)
            #                 <span className="verifyed"><span className="icon icon-mark"></span>已验证</span>
            #             else
            #                 <span className="verifyed"><span className="icon icon-delete"></span>未验证</span>
            #
            #     accountPanel = (
            #         <Panel className="u-mt-20 member-mobile-show">
            #             <span className="mobile" >您当前的手机号是：<code>{memberStore.mobile}</code></span>
            #             {isValid()}
            #         </Panel>
            #     )
            # 验证已有的手机
            when "verify-mobile"
                title = "验证手机号"
                isValid = ->
                    if(memberStore.mobile)
                        if(memberStore.is_mobile_valid)
                            <span className="verifyed"><span className="icon icon-mark"></span>已验证</span>
                        else
                            <span className="verifyed"><span className="icon icon-delete"></span>未验证</span>

                accountPanel = (
                    <Panel className="u-mt-20 member-mobile-show">
                        <span className="mobile" >您当前的手机号是：<code>{memberStore.mobile}</code></span>
                        {isValid()}
                    </Panel>
                )
            # 重置手机
            when "reset-mobile"
                title = "绑定新手机"

        return (
            <Page navbar-through className="member-register">
                {this.renderModal()}
                <Navbar leftNavbar={<BackButton />} title={title} />
                <PageContent className="bg-white">
                    <div className="form u-mt-50">

                        <Panel className={"u-none" if @props.type != "forgot"}>
                            <div className="u-pr region-box">
                                <div className="forget-switch-type" onClick={@onSwitchAccount}>{this.linkState("forgotSwitchText")}</div>
                                <Button className="forget-switch-type-icon" bsStyle="icon" icon="arrowdownlarge" onTap={@onSwitchAccount} />
                            </div>
                        </Panel>

                        <Panel className={SP.classSet(showEmailClass)}>
                            <div className="register-input">
                                <Input type="text" ref='account' valueLink={this.linkState("email")} placeholder="邮箱地址" />
                            </div>
                            <div className="form-error-info u-mt-10">{state.fieldError && state.fieldError.email && state.fieldError.email[0]}{state.emailError}</div>
                        </Panel>

                        {accountPanel}

                        <Panel>
                            <Grid className="register-picture-code" cols={24}>
                                <Col span={15}>
                                    <div className="register-input">
                                        <Input type="text" ref='sms' valueLink={this.linkState("pictureCode")} placeholder="图形验证码" />
                                    </div>
                                </Col>
                                <Col span={9} className="u-text-right">
                                    <div className="register-picture-code-btn">
                                        <img onClick={@getCaptcha} src={apihost+"/captcha"} alt="" className="captchaCode" id="captcha" />
                                    </div>
                                </Col>
                            </Grid>

                            <div className="form-error-info u-mt-10">{state.fieldError && state.fieldError.pictureCode && state.fieldError.pictureCode[0]}{state.pictureCodeError}</div>
                        </Panel>

                        <Panel className={SP.classSet(showMobileClass)}>
                            <Grid className="register-picture-code" cols={24}>
                                <Col span={15}>
                                    <div className="register-input">
                                        <Input type="text" ref='sms' onChange={this.onChangeSmsCode} value={state.code} placeholder="请输入验证码" />
                                    </div>
                                </Col>
                                <Col span={9} className="u-text-right">
                                    <div className="register-picture-code-btn">
                                        <Button className={"grayBgBtn"} disabled={state.time!=endTime} onTap={this.sendSms} outlined  >{state.codeBtnText}</Button>
                                    </div>
                                </Col>
                            </Grid>

                            <div className="form-error-info u-mt-10">{state.fieldError && state.fieldError.code && state.fieldError.code[0]}{state.codeError}</div>
                        </Panel>


                        <Panel>
                            <Button onTap={this.submitCode} disabled={this.getSubmitStatus()} block>{state.submitText}</Button>
                        </Panel>

                    </div>
                </PageContent>
            </Page>
        );

    render: ->
        self = this;
        state = this.state;
        memberStore = S("member")

        @renderMobile()
        # switch @props.type
        #     # 设置密码，如果是邮箱登录需要判断是否显示提示绑定的信息
        #     when "reset-pass"
        #         if(memberStore.mobile)
        #             return self.renderMobile();
        #         else
        #             return self.renderEmail();
        #     else
        #         return @renderMobile()

module.exports = PageView;
