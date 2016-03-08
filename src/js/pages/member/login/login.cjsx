pageStore = 'memberLogin';
MemberAuthMixin = require('modules/lib/mixins/member-auth-mixin')

PageView = React.createClass
    mixins: [liteFlux.mixins.storeMixin(pageStore),LinkedStateMixin,MemberAuthMixin()],
    getStateFromStore: ->
        return S(pageStore)

    setStateFromStore: ->
        if (this.isMounted())
            this.setState(S(pageStore));

    componentDidMount: ->

        # 如果已经登录
        if A("member").islogin()
            SP.redirect '/'
        else
            state = this.state;
            if(SP.storage.get('sipin_member_name'))
                this.refs.account.getDOMNode().value = SP.storage.get('sipin_member_name');
                state.account = SP.storage.get('sipin_member_name');

            S(pageStore,state);

    render: ->

        state = this.state;

        accountErrorClasses = SP.classSet
            'login-account-error-info': true,
            'u-hidden': !state.accountError.length

        passwordErrorClasses = SP.classSet
            'login-password-error-info': true,
            'u-hidden': !state.passwordError.length

        return (
            <Page className="member-login">
                <PageContent>
                    <div className="login-back-btn">
                        <BackButton />
                    </div>
                    <div className="logo">
                        <Icon name="loadinglogo" size={60} color="#d3af94" />
                        <Icon name="logotext01" size={60} color="#ffffff" />
                    </div>
                    <div className="form u-mt-30">

                        <Panel>
                            <div className="login-input">
                                <Input type="text" ref='account' valueLink={this.linkState("account")} onBlur={this.checkAccountWhenBlur} placeholder="手机号/邮箱/用户名" />
                            </div>
                            <div className={accountErrorClasses}>{state.accountError}</div>
                        </Panel>

                        <Panel>
                            <div className="login-input">
                                <Input type="password" ref="password" valueLink={this.linkState("password")} onBlur={this.checkPasswordWhenBlur} placeholder="密码" />
                            </div>
                            <div className={passwordErrorClasses}>{state.passwordError}</div>
                        </Panel>

                        <Panel className="login-remember-box">
                            <Grid className="u-mt-50" cols={24}>
                                <Col span={12}>
                                    <Checkbox onChange={this.checkRemember} checked={state.remember}>记住用户名</Checkbox>
                                </Col>
                                <Col span={12} className="u-text-right">
                                    <Link onTap={this.jumpForgotPass}>忘记密码</Link>
                                </Col>
                            </Grid>
                        </Panel>

                        <Panel>
                            <Button onTap={this.login} disabled={this.getSubmitStatus()} block>{state.submitText}</Button>
                        </Panel>

                        <Panel className="u-text-center login-bottom-panel">
                            <Button onTap={this.jumpRegister} outlined inverse>注册斯品</Button>
                        </Panel>

                    </div>
                </PageContent>
            </Page>
        );


module.exports = PageView;
