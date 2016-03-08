
PageView = React.createClass
    render: ->

        state = this.state;

        accountErrorClasses = {};

        data = {
            title: "成功重置密码",
            text: "请重新登录你的帐号",
            button:[
                {
                    text: "返回登录",
                    url: "/member/login"
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
