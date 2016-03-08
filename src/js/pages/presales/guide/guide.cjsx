React = require 'react'

PageView = React.createClass
    render: ->
        <Page navbar-through toolbar-through className="presales-guide">
            <Navbar leftNavbar={<BackButton />} rightNavbar={<HomeButton />} title="购买攻略" />
            <PageContent className="bg-white">
                <section>
                    <em>STEP1</em>
                    <h1>即将预售</h1>
                    <p>可提前了解产品，一分钱抢购代金券，并可以提前设置提醒。需注册斯品帐号。</p>
                </section>
                <section>
                    <em>STEP2</em>
                    <h1>提前登录</h1>
                    <p>根据预售时间准时开售，提前登录斯品商城做好预售购买准备。</p>
                </section>
                <section>
                    <em>STEP3</em>
                    <h1>首发预售</h1>
                    <p>仅限一天，以超低折扣进行销售，并且还是闪电发货。</p>
                </section>
                <section>
                    <em>STEP4</em>
                    <h1>限量预售</h1>
                    <p>错过了首发预售也没关系，在限量预售阶段同样可以以较低的折扣购买到心仪的产品</p>
                </section>
                <section>
                    <em>STEP5</em>
                    <h1>支付定金尾款</h1>
                    <p>按系统规定的时间，支付定金以及尾款，未及时支付可能会取消订单或者延期发货哟。</p>
                </section>
                <section>
                    <em>STEP6</em>
                    <h1>评价晒单</h1>
                    <p>按系统规定的时间，支付定金以及尾款，未及时支付可能会取消订单或者延期发货哟。</p>
                </section>
            </PageContent>
        </Page>

module.exports = PageView
