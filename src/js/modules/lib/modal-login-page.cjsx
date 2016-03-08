###
# Login Modal.
# @author thewei.
# @module Login
###
Modal = require 'components/lib/modals/modal'
LinkedStateMixin = require 'react/lib/LinkedStateMixin'
MemberAuthMixin = require './mixins/member-auth-mixin'

React = require 'react'
T = React.PropTypes
pageStore = 'memberLogin'


Message = React.createClass
    mixins: [liteFlux.mixins.storeMixin(pageStore),liteFlux.mixins.linkedStoreMixin,MemberAuthMixin()]
    getStateFromStore: ->
        liteFlux.store(pageStore).getStore()
    setStateFromStore: ->
        if (this.isMounted())
            this.setState(liteFlux.store(pageStore).getStore())
    propTypes:
        callback: T.func

    getDefaultProps: ->
        callback: () ->

    componentWillReceiveProps: (nextProps) ->
        @onShow()

    componentDidMount: ->
        state = @state
        state.modalShow = true

        if(SP.storage.get('sipin_member_name'))
            state.account = SP.storage.get('sipin_member_name');
        liteFlux.store(pageStore).setStore(state);

    componentWillUnmount: ->
        @onHide()
    onShow: () ->
        S pageStore,{
            modalShow: true
        }

    onHide: ->
        SP.loginboxshow = false
        @props.callback()
        S pageStore,{
            modalShow: false
        }
    onClose: ->
        @onHide()
        if !A("member").islogin()
            if this.props.logoutCallback
                this.props.logoutCallback()
        liteFlux.store(pageStore).reset();
    render: ->
        state = @state

        state = this.state;

        accountErrorClasses = SP.classSet
            'login-account-error-info': true,
            'u-hidden': !state.accountError.length

        passwordErrorClasses = SP.classSet
            'login-password-error-info': true,
            'u-hidden': !state.passwordError.length

        <Modal position={"bottom"} name="member-login-modal" onCloseClick={@onHide} show={@state.modalShow} margin={0}>
            <div className="login-back-btn">
                <Button onTap={@onClose} bsStyle="icon" icon="error" ></Button>
            </div>
            <div className="logo">
                <Icon name="loadinglogo" size={60} color="#d3af94" />
                <Icon name="logotext01" size={60} color="#ffffff" />
            </div>
            <div className="form u-mt-20">

                <Panel>
                    <div className="login-input">
                        <Input type="text" ref='account' valueLink={this.linkStore(pageStore,"account")} onBlur={this.checkAccountWhenBlur} placeholder="手机号/邮箱/用户名" />
                    </div>
                    <div className={accountErrorClasses}>{state.accountError}</div>
                </Panel>

                <Panel>
                    <div className="login-input">
                        <Input type="password" ref="password" valueLink={this.linkStore(pageStore,"password")} onBlur={this.checkPasswordWhenBlur} placeholder="密码" />
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
        </Modal>

module.exports = Message
