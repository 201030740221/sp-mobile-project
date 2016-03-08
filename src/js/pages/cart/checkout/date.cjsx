###
# Date.
# @author remiel.
# @module Checkout
###

Store = appStores.checkout
Action = Store.getAction()
T = React.PropTypes
DateBtn = React.createClass

    propTypes:
        onChange: T.func
        onCancel: T.func
        initDate: T.string
        selected: T.string

    getDefaultProps: ->
        onChange: (date)->

    getInitialState: ->
        modal: no


    setDeliveryDate: () ->
        @setState
            modal: yes

    onModalHide: () ->
        @setState
            modal: no

    onChange: (date) ->
        @props.onChange date, @props.type
        @onModalHide()


    renderDeliveryDateModal: () ->
        <Modal name={@props.type} onCloseClick={@onModalHide} show={@state.modal}>
            <DatePicker onChange={@onChange} onCancel={@onModalHide} selected={@props.selected || null} initDate={@props.initDate} lastDate={@props.end} />
        </Modal>

    render: ->
        type = ''
        switch @props.type
            when 'delivery'
                type = '配送'
            when 'install'
                type = '安装'
        text = if @props.selected then type + ' ' + @props.selected else "请选择" + type + "时间"
        <div>
            <Button block bsStyle='primary' onTap={@setDeliveryDate} className="u-f12">{text}</Button>
            {@renderDeliveryDateModal()}
        </div>

module.exports = DateBtn


Date = React.createClass

    onChange: (date, type) ->
        Action.setDate date, type

    render: ->
        help =
            <div className="u-pl-15 u-pr-15 u-pt-20 u-text-left u-color-gray-summary u-f14">
                · 根据您预约送装的日期起，物流公司在当地的服务商将会电话与您确定具体的日期和时段；
                <br />
                <br />
                · 受天气、交通等各类因素影响，您的订单有可能会出现延期；
                <br />
                <br />
                · 如因个人原因需要更改送装时间，请提交订单后在我的订单详情里进行修改。
            </div>

        <div className="form-box checkout-date u-mb-10">
            <header className="form-box-hd large-margin-top">
                预约送装时间
                <Alertable component={Button} bsStyle="icon" icon='help' contentElement={help} title="温馨提示" />
            </header>
            <div className="form-box-bd">
                <DateBtn type="delivery" onChange={@onChange} selected={@props.reserveDeliveryTime} initDate={@props.delivery} end={@props.end}/>
                <DateBtn type="install" onChange={@onChange} selected={@props.reserveInstallationTime} initDate={@props.reserveDeliveryTime || @props.install} end={@props.end}/>
            </div>
        </div>

module.exports = Date
