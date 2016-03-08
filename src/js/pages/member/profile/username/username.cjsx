pageStore = "member-username";
store = liteFlux.store(pageStore,{
    data: {
        name:'',
        errorInfo: ''
    }
});
Validator = liteFlux.validator;
validatorData = Validator(store,{
    'name':{
        required: true,
        minLength: 4,
        maxLength: 20,
        allNum: true,
        sipinusername: true,
        message: {
            required: "用户名不能为空",
            minLength: "最小长度不能小于4位",
            maxLength: "最大长度不能大于20位",
            sipinusername: "用户名只能使用字母、数字、下划线及中划线，长度为4-20个字符",
            allNum: "用户名不能为纯数字"
        }
    }
},{
    #oneError: true
});

validatorData.rule 'allNum', (val)->
    return !(/^\d+$/.test(val))

validatorData.rule 'sipinusername', (val)->
    return /^[a-zA-Z0-9_-]{4,20}$/.test val


PageView = React.createClass
    mixins: [liteFlux.mixins.storeMixin(pageStore),LinkedStateMixin,MemberCheckLoginMixin],
    # 如果未登录
    _logoutCallback: ->
        SP.redirect('/member',true);
    getStateFromStore: ->
        return S(pageStore)

    setStateFromStore: ->
        if (this.isMounted())
            this.setState(S(pageStore));

    isDisabled: ->
        return this.state.name.length<4;

    changeName: ->
        state = this.state;
        self = this;
        state.fieldError = {};
        state.errorInfo = '';
        S(pageStore,state);

        if !this.isDisabled() and validatorData.valid()

            # 通过服务端验证
            webapi.member.checkName({
                name: state.name
            }).then (res)->
                # 用户名是否存在
                if res && res.code == 0
                    SP.message
                        msg: "用户名已存在"
                        callback: ->
                else
                    #修改用户名
                    webapi.member.changeName({
                        name: state.name
                    }).then (res)->
                        if(res && res.code ==0)
                            # 更新 is_name_init
                            A("member").updateUserName(state.name)
                            # 发送提示
                            SP.message
                                msg: "用户名修改成功！",
                                callback: ->
                                    SP.back();
                        else
                            SP.message
                                msg: res.data.errors.name[0]
                                callback: ->

    render: ->
        state = this.state;

        return (
            <Page navbar-through className="profile-username">
                <Navbar leftNavbar={<BackButton />} title="修改用户名" />
                <PageContent className="bg-white">

                    <div className="form u-mt-30">

                        <Panel>
                            <div className="register-input">
                                <Input bottomBorder={true} placeholder="4-20个字符，可由字母、数字、符号等组成" valueLink={this.linkState("name")} />
                            </div>
                            <div className="form-error-info u-mt-10">{state.fieldError && state.fieldError.name && state.fieldError.name[0]}{state.errorInfo}{state.errorInfo}</div>
                        </Panel>

                        <Panel>
                            <Button onTap={this.changeName} disabled={this.isDisabled()} block>确认</Button>
                        </Panel>

                    </div>

                </PageContent>
            </Page>
        );

module.exports = PageView;
