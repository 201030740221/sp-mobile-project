module.exports = function(){
    var memberStore = require('stores/member');
    var pageStore = 'memberLogin';
    return {
        // 是否已登录
        _isLogin: function(){
            return liteFlux.action("member").getMemberFromLocalStore();
        },
        // 登录
        _loginSubmit: function(account,password,remember,callback){
            // TODO: 登录成功后需要加载到cookie里去
            // TODO: 需要把前一页的路由存到本地存储，做跳转
            webapi.member.login({
                account: account,
                password: password,
                remember: remember ? 1 : 0
            }).then(function(res){
                callback(res);
                // if(res&&res.code===0){ // 登录成功
                //     callback(res.data);
                // }else{ // 登录失败
                //     if(res&&res.code==1&&res.data.status===0){
                //         // TODO: 弱提示，<span>此帐号尚未激活，请<Link target="_blank" href={res.data.url}>马上激活</Link></span>
                //         callback(res.data);
                //     }else{
                //         // TODO：提示具体的错误信息
                //         callback(res.data);
                //     }
                // }
            });
        },
        _loginCheck: function(res,account,password,remember,callback){
            if(res && res.code !== 0){
                //alert('用户名或者密码不正确，请检查重试!');
                callback(false);
            }else{
                this._loginSubmit(account,password,remember,callback);
            }
        },
        _login: function(account,password,remember,callback){
            var self = this;
            // 检查用户名是否存在
            if(SP.validator.email(account)){  // 如果是邮箱
                webapi.member.checkEmail({
                    email: account
                }).then(function(res){
                    self._loginCheck(res,account,password,remember,callback);
                });
            }else if(account.length===11 && SP.validator.phone(account)){ // 如果是手机
                webapi.member.checkMobile({
                    mobile: account
                }).then(function(res){
                    self._loginCheck(res,account,password,remember,callback);
                });
            }else{
                webapi.member.checkName({
                    name: account
                }).then(function(res){
                    self._loginCheck(res,account,password,remember,callback);
                });
            }


        },
        // 退出
        _logout: function(){
            memberStore.reset();
        },
        login: function(e){

            e.preventDefault();
            e.stopPropagation();

            var state = this.state,
                self = this,
                validatorData = liteFlux.action("memberLogin").validatorData();

            state.accountError = "";
            state.passwordError = "";
            state.fieldError = {};
            liteFlux.store("memberLogin").setStore(state);
            // 如果按钮准备好了
            if(!this.getSubmitStatus() && validatorData.valid()){
                state.submitText = "登录中...";


                this._login(state.account,state.password,state.remember,function(res){

                    //登录成功
                    if(res===false){
                        state.submitText = "登录";
                        state.accountError = "帐号或者密码不正确，请检查重试!";
                    }else{
                        if(res&&res.code===0){

                            if(state.remember){
                                SP.storage.set('sipin_member_name',state.account);
                            }else{
                                SP.storage.remove('sipin_member_name');
                            }

                            liteFlux.action("member").login(res.data);

                            SP.message({
                                msg: "登录成功！",
                                callback: function(){
                                    //SP.redirect('/');
                                    state.submitText = "登录成功";
                                    state.modalShow = false;
                                    liteFlux.store(pageStore).setStore(state);
                                    // 重置登录数据
                                    liteFlux.store("memberLogin").reset();
                                    // callback
                                    if(self.props.success){
                                        self.props.success();
                                    }
                                }
                            });


                        }else{
                            if(res&&res.code==1&&res.data.status===0){
                                var _info = (
                                    <span>此帐号尚未激活，请<Link target="_blank" href={res.data.url}>马上激活</Link></span>
                                );
                                state.submitText = "登录";
                                state.accountError = _info();
                            }else{
                                // 提示错误信息
                                state.submitText = "登录";
                                state.accountError = "帐号或者密码不正确，请检查重试!";
                            }
                        }
                    }

                    liteFlux.store(pageStore).setStore(state);

                });
                liteFlux.store(pageStore).setStore(state);
            }

        },
        getSubmitStatus: function(){
            var state = this.state;
            // 帐号、密码不为空，且没有错误信息
            return !(state.account.length>=state.accountLength && state.password.length>=state.passwordLength) || state.submitText==="登录中...";
        },
        jumpRegister: function(){
            state = this.state;
            state.modalShow = false;
            liteFlux.store(pageStore).setStore(state);
            liteFlux.store(pageStore).reset();
            SP.storage.set('referrer_url',window.location.hash.replace('#!',''));
            SP.redirect('/member/register');
        },
        jumpForgotPass: function(){
            state = this.state;
            state.modalShow = false;
            liteFlux.store(pageStore).setStore(state);
            liteFlux.store(pageStore).reset();
            SP.redirect('/member/profile/mobile/forgot');
        },
        // 失去焦点时检查用户名长度
        checkAccountWhenBlur: function(){
            var state = this.state;
            if(state.account.length>0 && state.account.length<state.accountLength){
                state.accountError = '请输入正确的用户名/手机';
            }else{
                state.accountError = '';
            }
            liteFlux.store(pageStore).setStore(state);
        },
        // 失去焦点时检查密码长度
        checkPasswordWhenBlur: function(){
            var state = this.state;
            if(state.password.length>0 && state.password.length<state.passwordLength){
                state.passwordError = '请输入正确的密码';
            }else{
                state.passwordError = '';
            }
            liteFlux.store(pageStore).setStore(state);
        },
        // 记住用户名
        checkRemember: function(res){
            var state = this.state;
            state.remember = res;
            liteFlux.store(pageStore).setStore(state);
        },
        forgotPassword: function(){
            state = this.state;
            state.modalShow = false;
            liteFlux.store(pageStore).setStore(state);
            liteFlux.store(pageStore).reset();
            SP.redirect('/member/forgot_password');
        }
    };
};
