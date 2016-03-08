###
# 关键词近似结果建议框
# @author tofishes
###
SuggestionStore = require 'stores/suggestion'
actions = SuggestionStore.getAction()

Suggestion = React.createClass
    mixins: [liteFlux.mixins.storeMixin('suggestion')],
    onModalHide: ->
        actions.resetList()

    render: ->
        data = this.state.suggestion
        keyword = data.keyword
        re = new RegExp '(' + keyword + ')', 'gi'
        items = data.list.map (item)->
            # item = {"id":34,"title":"\u5723\u8bfa\u5c14 \u6c99\u53d1\u5e8a","sku_id":133,"sku_sn":"272319","url":"http:\/\/www.sipin.test\/item\/272319.html"}

            title = item.title.replace(re, '<span class="high-light">$1</span>')
            return (
                <Link component="li" key={item.sku_id} href={"/item/" + item.sku_sn} dangerouslySetInnerHTML={__html: title}></Link>
            )

        show = this.state.suggestion.list.length > 0

        classes = SP.classSet
            'suggestion': true
            'u-none': !show

        return (
            <Modal name="suggestion" maskClose={true} onCloseClick={@onModalHide} show={show} position="top">
                <div className={classes}>
                    <ul>
                        {items}
                    </ul>
                </div>
            </Modal>
        )

module.exports = Suggestion
