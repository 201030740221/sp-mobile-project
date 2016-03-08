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
    mixins: [liteFlux.mixins.storeMixin(pageStore),LinkedStateMixin,MemberAuthMixin()]
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

    onShow: () ->
        @setState
            modalShow: true

    onHide: ->
        @props.callback()
        @setState
            modalShow: false
    render: ->
        state = @state
        <Modal name="login-modal" title="帐号登录" onCloseClick={@onHide} show={@state.modalShow}>
            <div className="form u-mt-30">

                <Panel>
                    <div>
                        <Input type="text" ref='account' valueLink={this.linkState("account")} onBlur={this.checkAccountWhenBlur} placeholder="手机号/邮箱/用户名" />
                    </div>
                    <div className="u-color-blackred u-mt-5">{state.fieldError && state.fieldError.account && state.fieldError.account[0]}{state.accountError}</div>
                </Panel>

                <Panel>
                    <div>
                        <Input type="password" ref="password" valueLink={this.linkState("password")} onBlur={this.checkPasswordWhenBlur} placeholder="密码" />
                    </div>
                    <div className="u-color-blackred u-mt-5">{state.fieldError && state.fieldError.password && state.fieldError.password[0]}{state.passwordError}</div>
                </Panel>

                <Panel>
                    <Grid className="u-mt-30" cols={24}>
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

                <Panel className="u-text-center u-pb-10">
                    <Button onTap={this.jumpRegister} bsStyle='link' className='u-f12' > 还不是斯品用户？马上注册</Button>
                </Panel>

            </div>
            {#@props.children}
        </Modal>

module.exports = Message
