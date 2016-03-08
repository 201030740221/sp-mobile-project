var Store = appStores.goodsCategories;
var SearchInput = require('components/lib/search-input')


/**
 * menu list item
 */
var MenuItem = React.createClass({
    render: function() {
        var item = this.props.item
        ,   type = this.props.type;

        var renderChild = function () {
            if (item.children && item.children.length) {
                return <ItemDetail item={item.children} type={ type }></ItemDetail>
            }
            return null;
        }

        return (
            <li>
                <h4><Link href={"/category/"+item.id}>{item.name}</Link></h4>
                { renderChild() }
            </li>
        )
    }
});


/**
 * menu item detail
 */
var ItemDetail = React.createClass({
    render: function() {
        var itemDetail = this.props.item;
        var item_classes , list_classes;

        var type = this.props.type;
        if(type == "list"){
            item_classes = 'item_content menu_item_content';
            list_classes = 'search-item-list menu-list';
        }
        if(type == "search"){
            item_classes = 'item_content';
            list_classes = 'search-item-list';
        }
        var detailNode = itemDetail.map(function(item) {
            return (
                <div key={item.id}>
                    <Link className={item_classes} href={"/category/"+item.id}>{item.name}</Link>
                </div>
            )
        });
        return (
            <div className={list_classes}>
                {detailNode}
            </div>
        )
    }
});


var PageView = React.createClass({
    mixins: [liteFlux.mixins.storeMixin('categories')],
    componentDidMount: function () {
        // SP.loading(true)
        liteFlux.action("categories").getGoodsCategories();
    },

    keywordChange: function (keyword) {
        this.searching.keyword = keyword
    },
    searching: function () {
        S('suggestion', {
            list: []
        })
        var keyword = this.searching.keyword;

        if (! keyword) return;

        // 99click 搜索统计
        if(sipinConfig.env === "production"){
            setTimeout(function(){
                liteFlux.event.emit('click99',"search", "keyword="+encodeURIComponent(keyword) );
            },500);
        }

        SP.redirect('/search/' + encodeURIComponent(keyword));
    },
    render: function() {
        // SP.loading()
        /*接收数据*/
        var data = this.state.categories.categories;

        /*数据对象转为数组*/
        var data_arr = [];
        for(var index in data) {
            data_arr.push(data[index]);
        }
        /*热门搜索*/
        var hotNode = (
                <div>
                    <li>
                        <div className="small-title">热门搜索：</div>
                        <div className="search-item-list">
                            <Link className="item_content" href="/search/木床">木床</Link>
                            <Link className="item_content" href="/search/木桌子">木桌子</Link>
                            <Link className="item_content" href="/search/原木沙发">原木沙发</Link>
                            <Link className="item_content" href="/search/茶几">茶几</Link>
                            <Link className="item_content" href="/search/皮质沙发">皮质沙发</Link>
                            <Link className="item_content" href="/search/木凳">木凳</Link>
                            <Link className="item_content" href="/search/窗饰">窗饰</Link>
                        </div>
                    </li>
                    <div className="small-title" style={{marginTop:'20',marginBottom:'-10'}}>按分类搜索：</div>
                </div>
        );
        // TODO 暂时隐藏热门搜索
        hotNode = '';

        /*判断接收的type, type为list就是类目ui type为search就是搜索ui*/
        type = this.props.type;

        if(type == "list"){
            hotNode = "";
        }
        /*类目*/
        var itemNode = data_arr.map(function(item){
            return (
                <MenuItem key={item.id} item={item} type={type}></MenuItem>
            )
        });

        var nav_right = <div className="search-btn" onClick={this.searching}>搜索</div>

        return (
            <Page  navbar-through>
                <Navbar leftNavbar={<BackButton />} rightNavbar={nav_right}>
                    <SearchInput placeholder="搜索您需要的商品" onChange={this.keywordChange} value={this.searching.keyword} />
                </Navbar>
                <Suggestion/>
                <PageContent className="bg-white">
                    <ul className="goods-search-menu">
                        {hotNode}
                        {itemNode}
                    </ul>
                </PageContent>
            </Page>
        );
    }

});

module.exports = PageView;
