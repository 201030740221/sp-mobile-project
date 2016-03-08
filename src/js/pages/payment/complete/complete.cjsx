
Store = appStores.payment
Action = Store.getAction()
PageView = React.createClass
    mixins: [MemberCheckLoginMixin, liteFlux.mixins.storeMixin('payment')]
    getInitialState: ->
        Action.init @props.id
        {}

    componentWillReceiveProps: (nextProps) ->
        Action.init nextProps.id

    componentDidMount: ->
        #99click 订单下单成功
        if sipinConfig.env == "production"
            webapi.tools.orderAnalytics({
                order_no: this.props.no
            }).then (result)->
                if result && result.code == 0
                    liteFlux.event.emit('click99',"order-complete", result.data.code);

    componentWillUnmount: ->
        Action.reset()

    render: ->
        order = @state['payment'].order
        if not order
            return <Loading />
        # else
        #     point = Math.ceil detail.total
        # if isNaN point
        #     title =
        #         <div>支付成功</div>
        # else
        #     title =
        #         <div>支付成功, 并获得<span className="u-color-blackred">{point}</span>积分</div>

        title =
            <div>支付成功</div>
        data = {
            title: title,
            text: "订单号 "+this.props.no+"，我们会尽快为您发货",
            button:[
                {
                    text: "继续购物",
                    url: "/"
                },
                {
                    text: "查看订单详情",
                    url: "/member/order/detail/"+this.props.id
                }
            ]
        }

        return (
            <Page className="member-register">
                <PageContent className="bg-white">
                    <CompletePage data={data} />
                </PageContent>
            </Page>
        );

module.exports = PageView;
