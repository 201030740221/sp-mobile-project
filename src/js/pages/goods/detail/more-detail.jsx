var React = require('react');
var Store = appStores.goodDetail;
var CartStore = appStores.cart;
var GoodFooterNav = require('pages/goods/detail/footer-nav');
var PageView = React.createClass({
    mixins: [liteFlux.mixins.storeMixin('detail')],
    componentDidMount: function () {
        liteFlux.action("detail").getGoodDetails(this.state.sku_sn,this.state.detail.delivery_region_id);
    },
    getInitialState: function() {
        return {
            'sku_sn': this.props.id
        }
    },
    componentWillReceiveProps: function(props) {
        liteFlux.action("detail").getGoodDetails(props.id,this.state.detail.delivery_region_id);
    },
    componentWillUnmount: function () {
        //liteFlux.store("detail").reset()
    },
    render: function() {
        var title  = '更多详情';
        var data = this.state.detail.goodData; /*商品信息*/
        var mobile_content = '数据加载中...';
        var GoodFooterNavHTML = '';

        if( data && data.baseData ){
            mobile_content = data.baseData.mobile_content || "<div>亲，已经没有更多信息了</div>";
            GoodFooterNavHTML = (<GoodFooterNav g_id = { data.baseData.goods_sku_id }></GoodFooterNav>);
        }
        return (
            <Page navbar-through toolbar-through>
                <Navbar leftNavbar={<BackButton />}  rightNavbar={<HomeButton />} title={title}></Navbar>
                <PageContent className="bg-white">
                    <div dangerouslySetInnerHTML={{__html: mobile_content}}></div>
                </PageContent>
                <Toolbar>
                    {GoodFooterNavHTML}
                </Toolbar>
            </Page>
        );
    }

});

module.exports = PageView;
