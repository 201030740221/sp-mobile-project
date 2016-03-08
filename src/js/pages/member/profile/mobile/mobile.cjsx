timer = null;

pageStore = 'member-mobile';

PageView = React.createClass
    mixins: [liteFlux.mixins.storeMixin(pageStore),LinkedStateMixin],
    getStateFromStore: ->
        return S(pageStore)
    setStateFromStore: ->
        if (this.isMounted())
            this.setState(S(pageStore));
    componentDidMount: ->
        liteFlux.store(pageStore).reset();

    # 设置按钮是否高亮
    isDisabled: ->
        return this.state.mobileCodeError || this.state.pictureCodeError;
    # 设置时间
    setTimer: ->
        self = this;
        state = this.state;
        timer = null;
        state.second = 59;
        timer = setInterval ->
            if( state.second>0 && state.second !=60 )
                state.second = state.second - 1;
                self.setState(state);
            else
                self.clearTimer();

    clearTimer: ->
        clearInterval(timer);
        state = this.state;
        state.second = 60;
        this.setState(state);

    sendmobileCode: ->
        self = this;
        state = this.state;

        webapi.member.sendSms({
            captcha: state.pictureCode, # 图形验证码
            type: 2,
            mobile: state.mobileCode
        }).then (res)->
            # 发送成功
            if( res && res.code )
                # 开始计时
                state.successInfo = '短信验证码已发送，请注意查收';
                self.clearTimer();
                self.setTimer();
            else
                # 发送失败
                state.errorInfo = '手机验证码发送失败，请重试';

            self.setState(state);

    # 获得手机验证码
    getmobileCode: ->
        self = this;
        state = this.state;
        # 正则验证手机格式
        if(true)
            state.errorInfo = "手机格式不正确";
        else
            # 是否正在读秒期间
            if(true)
                # 验证手机是否存在
                webapi.member.checkMobile({
                    mobile: state.mobileCode
                }).then (res)->
                    # 如果存在
                    if(res && res.code == 0 )
                        state.errorInfo = '手机号已被注册';
                    else
                        # 发送手机验证码
                        self.sendmobileCode();

                    self.setState(state);


        this.setState(state);

    # 验证手机验证码
    verifymobileCode: ->

        self = this;
        state = this.state;

        webapi.member.changeMobile({
            sms_code: state.mobileCode,
            mobile: "手机号",
            member_id: "用户ID"
        }).then (res)->
            # 修改成功
            if(res && res.code ==0 )
                console.log("修改成功");
            else
                # 修改失败
                console.log("修改失败");

    # 刷新图形验证码
    refreshPictureCode: ->

    # 验证图形验证码
    verifyPictureCode: ->
        self = this
        state = this.state

        # 正则验证
        if(true)

        else
            webapi.member.checkCaptcha({
                captcha: state.pictureCode
            }).then (res)->
                #  验证成功
                if( res && res.code )
                    console.log("验证成功");
                else
                    # 验证失败
                    console.log("验证失败");



    getSubmitStatus: ->
        state = this.state;
        # 帐号、密码不为空，且没有错误信息
        return !(state.account.length==11 && !state.accountError.length) || !(state.code.length==6 && !state.codeError.length) || state.submitText=="正在检验验证码...";

    render: ->
        state = this.state;
        memberStore = S("member")

        # 返回手机号码
        mobileHtml = ->

            isValid = ->
                if(memberStore.mobile)
                    if(memberStore.is_mobile_valid)
                        return (
                            <span className="verifyed">已验证</span>
                        )
                    else
                        return (
                            <span className="verifyed">未验证</span>
                        )



            return (
                <Panel className="u-mt-20 member-mobile-show">
                    <span className="mobile" >您当前的手机号是：<code>{memberStore.mobile}</code></span>
                    {isValid()}
                </Panel>
            )


        return (
            <Page navbar-through className="member-mobile">
                <Navbar leftNavbar={<BackButton />} title="修改手机号" />
                <PageContent className="bg-white">
                    <div className="form">

                        {mobileHtml()}

                        <Panel className="member-mobile-code">
                            <Grid className="register-picture-code" cols={24}>
                                <Col span={15}>
                                    <div className="register-input">
                                        <Input type="text" ref='sms' valueLink={this.linkState("code")} placeholder="短信验证码" />

                                    </div>
                                </Col>
                                <Col span={9} className="u-text-right">
                                    <div className="register-picture-code-btn">
                                        <Button disabled={state.time!=90} onTap={this.sendSms} outlined  >{state.codeBtnText}</Button>
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


module.exports = PageView;
