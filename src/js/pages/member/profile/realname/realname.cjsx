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
        maxLength: 8,
        name: true,
        message: {
            required: "用户名不能为空",
            minLength: "最小长度不能小于4位",
            maxLength: "最大长度不能大于8位",
            username: "格式错误，请输入4-8个中文字符，不允许标点符号"
        }
    }
},{
    #oneError: true
});

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
        if(!this.isDisabled())
            S(pageStore,state);
            if(validatorData.valid())
                # 通过服务端验证
                webapi.member.checkName({
                    name: state.name
                }).then (res)->
                    # // 用户名是否存在
                    # // if(res && res.code === 0){
                    # //     state.errorInfo = "用户名已存在";
                    # // }else{
                    # //     //修改用户名
                    # //     webapi.changeName({
                    # //         member_id: "用户ID",
                    # //         name: state.name
                    # //     }).then(function(res){
                    # //         if(res && res.code ===0){
                    # //             sp.message({
                    # //                 msg: "用户名修改成功！",
                    # //                 callback: function(){
                    # //                     SP.redirect("/member/profile");
                    # //                 }
                    # //             });
                    # //         }else{
                    # //             sp.message({
                    # //                 msg: "用户名修改失败，请重新尝试！",
                    # //                 callback: function(){
                    # //
                    # //                 }
                    # //             });
                    # //         }
                    # //     });
                    # // }
                    # // self.setState(state);

    render: ->
        state = this.state;

        return (
            <Page navbar-through className="profile-username">
                <Navbar leftNavbar={<BackButton />} title="修改姓名" />
                <PageContent className="bg-white">

                    <div className="form u-mt-30">

                        <Panel>
                            <div className="register-input">
                                <Input bottomBorder={true} placeholder="输入您的真实中文姓名，4-8个字符" valueLink={this.linkState("name")} />
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
