PageView = React.createClass
    render: ->

        state = this.state;

        data = {
            title: "注册成功",
            text: "感谢您对斯品的支持，您可以",
            button:[
                {
                    text: "去首页购物",
                    url: "/"
                },
                {
                    text: "完善个人资料",
                    url: "/member/profile"
                }
            ]
        }

        if SP.storage.get('referrer_url')
            referrer_url = SP.storage.get('referrer_url')
            data.button.unshift {
                text: "返回上一页",
                url: referrer_url,
                bsStyle: 'primary',
                outlined: true
            }
            SP.storage.remove('referrer_url')

        return (
            <Page className="member-register">
                <PageContent className="bg-white">
                    <CompletePage data={data} />
                </PageContent>
            </Page>
        );

module.exports = PageView;
