###
# ShareWeixin.
# @author remiel.
# @module Share
#
###

Weixin = React.createClass
    mixins: [liteFlux.mixins.storeMixin('share')]

    getInitialState: ->
        A('share').setQrcodeUrl decodeURIComponent @props.url
        A('share').getQrcode()
        {}

    componentWillUnmount: ->
        A('share').resetQrcode()

    render: ->
        img = ""
        # if @state.share.qrcode isnt null
        #     img = <Img width="150" src={@state.share.qrcode} />
        img = <Img width="150" src={window.apihost + '/qrcode?return_type=image&url=' + encodeURIComponent(decodeURIComponent @props.url)} />
        <Page navbar-through toolbar-through className="share">
            <Navbar leftNavbar={<BackButton />} title="微信分享"></Navbar>
            <PageContent className="bg-white">
                <div className="share-weixin">
                    <h4>获取分享链接</h4>
                    <p className="u-mt-10">以下是你的专属二维码及专属链接，长按即可复制链接或截屏发给好友。</p>
                    <div className="u-text-center u-mt-15">
                        {img}
                    </div>
                    <div className="form u-mt-30">
                        <Input type="text" defaultValue={decodeURIComponent @props.url}/>
                    </div>
                </div>
            </PageContent>
        </Page>

module.exports = Weixin
