module.exports =
    _checkLogin: ->
        self = this
        if(!liteFlux.action("member").islogin())
            #SP.loginbox();
            #SP.redirect('/member/login');
            if !SP.loginboxshow
                SP.loginboxshow = true
                SP.loadLogin
                    success: ->
                        window.location.reload();
                    logoutCallback: self._logoutCallback || null

    componentDidMount: ->
        this._checkLogin();
