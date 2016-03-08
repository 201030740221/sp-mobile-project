
PageView = React.createClass
    onBack: ->
        window.history.back(-1);

    goToHome: ->
        SP.redirect('/');
    render: ->
        btn = <Button bsStyle='primary' large className="u-mt-10" onTap={@goToHome}>返回首页</Button>
        texts = [
            "你访问的页面不存在"
            "您可以回首页挑选喜欢的商品"
        ]
        return (
            <Page navbar-through className="error-404">
                <Navbar title="页面不存在" />
                <PageContent className="bg-white">
                    <div className="form u-mt-50">

                        <Empty btn={btn} texts={texts}/>

                    </div>
                </PageContent>
            </Page>
        )

module.exports = PageView
