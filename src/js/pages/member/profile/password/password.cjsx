pageStore = 'member-password';

PageView = React.createClass
    mixins: [liteFlux.mixins.storeMixin(pageStore),LinkedStateMixin],
    getStateFromStore: ->
        return SP.assign( S(pageStore), {
            isDisable: false
        })

    setStateFromStore: ->
        if (this.isMounted())
            this.setState(S(pageStore))

    setPassword: ->
        self = this;
        S(pageStore,@state);
        if !@getSubmitStatus()

            switch @props.type
                # 修改登录密码
                when "change"
                    if A(pageStore).validatorData().valid()
                        webapi.member.changePassword({
                            old_password: S(pageStore).oldpassword
                            password: S(pageStore).password
                        }).then (res)->
                            if res && res.code == 0
                                SP.message
                                    msg: "修改登录密码成功"
                                    callback: ->
                                        SP.back()
                            else
                                SP.message
                                    msg: res.msg
                # 注册登录密码
                when "new"
                    if A(pageStore).validatorData().valid("password") and A(pageStore).validatorData().valid("repassword")

                        data = {
                            account: S("member-mobile-temp").account,
                            sms_code: S("member-mobile-temp").sms_code
                            password: S(pageStore).password
                            password_confirmation: S(pageStore).repassword
                        }

                        if S("member-mobile-temp").referral_code
                            data.referral_code = S("member-mobile-temp").referral_code

                        this.setState({
                            isDisable: true
                        });
                        webapi.member.register(data).then (res)->
                            self.setState({
                                isDisable: false
                            });
                            if res && res.code == 0
                                A('member').setMemberInformation();
                                # 99click 注册事件
                                if(sipinConfig.env == "production")
                                    setTimeout ->
                                        _ozprm = "user_id=" + res.data.analytics_user_key;
                                        liteFlux.event.emit('click99',"register", _ozprm );
                                    , 500

                                if S("member-mobile-temp").referral_code
                                    SP.redirect '/member/register/invite',true
                                else
                                    SP.redirect '/member/register/complete',true
                                liteFlux.store("member-mobile-temp").reset()
                            else
                                SP.message
                                    msg: res.msg
                # 重置登录密码
                when "reset"
                    if A(pageStore).validatorData().valid("password") and A(pageStore).validatorData().valid("repassword")
                        webapi.member.resetPassword({
                            account: S("member-mobile-temp").account,
                            sms_code: S("member-mobile-temp").sms_code
                            password: S(pageStore).password
                            password_confirmation: S(pageStore).repassword
                        }).then (res)->
                            if res && res.code == 0
                                SP.redirect '/member/forgot/complete',true
                                liteFlux.store("member-mobile-temp").reset()
                            else
                                SP.message
                                    msg: res.msg

    getSubmitStatus: ->
        return @state.password.length<6 || @state.repassword.length<6 || @state.isDisable
    componentDidMount: ->
        liteFlux.store(pageStore).reset()
        #console.log @props.type
    onBack: ->
        if window.location.hash.replace('#!','') == '/member/profile/password/new'
            SP.redirect '/member/register', true
        else
            SP.back()
    render: ->

        state = this.state;
        accountErrorClasses = {};

        oldpasswordPanel = '';

        switch @props.type
            when "change"
                title = "修改登录密码"
                oldpasswordPanel = (
                    <Panel>
                        <div className="register-input">
                            <Input type="password" ref='oldpassword' valueLink={this.linkState("oldpassword")} placeholder="旧密码" />
                        </div>
                        <div className="form-error-info u-mt-10">{state.fieldError && state.fieldError.oldpassword && state.fieldError.oldpassword[0]}</div>
                    </Panel>
                )
            when "new"
                title = "设置登录密码"
            when "reset"
                title = "重置登录密码"

        return (
            <Page navbar-through className="member-register">
                <Navbar leftNavbar={<BackButton onTap={this.onBack} />} title={title} />
                <PageContent className="bg-white">
                    <div className="form u-mt-50">

                        {oldpasswordPanel}

                        <Panel>
                            <div className="register-input">
                                <Input type="password" ref='password' valueLink={this.linkState("password")} placeholder="设置密码" />
                            </div>
                            <div className="form-error-info u-mt-10">{state.fieldError && state.fieldError.password && state.fieldError.password[0]}</div>
                        </Panel>

                        <Panel>

                            <div className="register-input">
                                <Input type="password" ref='repassword' valueLink={this.linkState("repassword")} placeholder="确认密码" />
                            </div>
                            <div className="form-error-info u-mt-10">{state.fieldError && state.fieldError.repassword && state.fieldError.repassword[0]}</div>

                        </Panel>

                        <Panel>
                            <Button disabled={@getSubmitStatus()} onTap={this.setPassword} block>完成</Button>
                        </Panel>

                    </div>
                </PageContent>
            </Page>
        );
#

module.exports = PageView;
