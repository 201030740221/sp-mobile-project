var React = require('react');
var Store = appStores.flashSale;
var CartStore = appStores.cart;
var GoodFooterNav = require('pages/goods/flash-sale/footer-nav');
var PageView = React.createClass({
    mixins: [liteFlux.mixins.storeMixin('flashsale')],
    componentDidMount: function () {
        liteFlux.action("flashsale").getGoodDetails(this.state.sku_sn,this.state.flashsale.delivery_region_id);
    },
    getInitialState: function() {
        return {
            'sku_sn': this.props.id
        }
    },
    componentWillReceiveProps: function(props) {
        liteFlux.action("flashsale").getGoodDetails(props.id,this.state.flashsale.delivery_region_id);
    },
    componentWillUnmount: function () {
        A('flashsale').closeChannel();
        liteFlux.store("flashsale").reset();
    },
    render: function() {
        var title  = '更多详情';
        var data = this.state.flashsale.goodData; /*商品信息*/
        if(data == undefined || data == null)
            return <Loading />;

        if(data.baseData === undefined || data.baseData === null)
            return <Loading />;
        var mobile_content = data.baseData.mobile_content;
        if(mobile_content === "" || mobile_content === null){
            mobile_content = "<div>亲，已经没有更多信息了</div>"
        }
        return (
            <Page navbar-through toolbar-through>
                <Navbar leftNavbar={<BackButton />}  rightNavbar={<HomeButton />} title={title}></Navbar>
                <PageContent className="bg-white">
                    <div style={{padding:20}} dangerouslySetInnerHTML={{__html: mobile_content}}></div>
                </PageContent>
                <Toolbar>
                    <GoodFooterNav g_id = { data.baseData.goods_sku_id }></GoodFooterNav>
                </Toolbar>
            </Page>
        );
    }

});

module.exports = PageView;
