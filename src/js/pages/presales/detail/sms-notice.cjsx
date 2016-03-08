React = require 'react'

View = React.createClass
    getInitialState: ->
        showModal: no
        fieldError: {}
        random: Math.random()

    onModalShow: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        @setState
            showModal: yes
    onModalHide: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        @setState
            showModal: no

    cancel:() ->
        @onModalHide()

    confirm:() ->
        if not @validMobile()
            SP.message
                msg: '请输入正确的手机号码'
            return no
        else if not @validCaptcha()
            SP.message
                msg: '请输入正确的验证码'
            return no
        else if @validMobile() and @validCaptcha()
            webapi.presales.setMessageReminder(
                type: 1
                requester_id: @props.id
                target: @refs['mobile'].getDOMNode().value
                captcha: @refs['captcha'].getDOMNode().value
                # sms_code:
            ).then (res) =>
                @setState
                    random: Math.random()
                if res and res.code is 0
                    @onModalHide()
                    SP.message
                        msg: '设置成功'
                else
                    SP.message
                        msg: res.msg
        # else
        #     SP.message
        #         msg: '请输入正确的手机号码'
        yes

    onTap: (e) ->
        e.preventDefault()
        e.stopPropagation()
        if @isLogin()
            @onModalShow()
            @props.onTap() if @props.onTap?
        else
            @login()
    isLogin: () ->
        isLogin = A("member").islogin()

    login: (callback, e) ->
        if typeof e isnt 'object' and typeof callback is 'object'
            e = callback
            e.stopPropagation()
            e.preventDefault()
        SP.loadLogin
           success: ->
               if callback and typeof callback is 'function'
                   callback()
               else
                   window.location.reload()
    renderModal: ->
        <Alert name="sms-notice" confirm={@confirm} cancel={@cancel} bsStyle="red-yellow" show={@state.showModal} confirmText="提交">{@renderContent()}</Alert>

    renderTitle: () ->
        if @props.title
            <div className="u-text-center"><br />{@props.title}</div>
    renderDesc: () ->
        if @props.desc
            <div><br />{@props.desc}</div>

    onBlur: (e) ->
        el = e.target
        name = el.name
        switch name
            when 'mobile' then @validMobile()
            when 'captcha' then @validCaptcha()
        ''
    onFocus: (e) ->
        el = e.target
        name = el.name
        @resetError name

    getCaptcha: ->
        # @refs['captcha-img'].getDOMNode().src = apihost + '/captcha?' + Math.random()
        @setState
            random: Math.random()

    validCaptcha: () ->
        # webapi.member.checkCaptcha(captcha: @refs['captcha'].getDOMNode().value).then (res) =>
        #     if res.code is 0
        #
        #     else
        #         @setError 'captcha', '请输入正确的验证码'
        #         no
        value = @refs['captcha'].getDOMNode().value
        if value and value.length
            yes
        else
            @setError 'captcha', '请输入正确的验证码'
            no

    validMobile: () ->
        value = @refs['mobile'].getDOMNode().value
        if value and value.length
            valid = /^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$/.test @refs['mobile'].getDOMNode().value
        else
            valid = no
        if valid
            @resetError 'mobile'
        else
            @setError 'mobile', '请输入正确的手机号码'

        valid

    setError: (name, value) ->
        error = @state.fieldError
        error[name] = value
        @setState
            fieldError: error

    resetError: (name) ->
        if name
            error = @state.fieldError
            error[name] = ''
        else
            error = {}
        @setState
            fieldError: error


    renderContent: () ->
        <div className="u-ml-20 u-mr-20">
            <div className="u-f14">
                {@renderTitle()}
                {@renderDesc()}
            </div>
            <div className="form u-mt-10">
                <Input ref="mobile" className="form-control" type="text" placeholder="手机号码" onBlur={@onBlur} onFocus={@onFocus} name="mobile" />
                <div className="form-error-info u-mt-10">{@state.fieldError['mobile']}</div>
            </div>
            <Grid className="form u-mt-10" cols={24}>
                <Col className="u-pr-20" span={16}>
                    <Input ref="captcha" className="form-control" type="text" placeholder="验证码" onBlur={@onBlur} onFocus={@onFocus} name="captcha" />
                </Col>
                <Col span={8}>
                    <img onClick={@getCaptcha} ref="captcha-img" src={apihost+"/captcha?"+@state.random} alt="" className="captcha" />
                </Col>
                <Col span={24}>
                    <div className="form-error-info u-mt-10">{@state.fieldError['captcha']}</div>
                </Col>
            </Grid>
        </div>


    render: () ->
        <Tappable {...@props} onTap={@onTap}>
            {@props.children}
            {@renderModal()}
        </Tappable>


module.exports = View
