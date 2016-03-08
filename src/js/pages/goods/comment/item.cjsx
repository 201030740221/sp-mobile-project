###
# Comment
# @author remiel.
# @page Comment
###
Store = appStores.comment
Action = Store.getAction()
SliderBox = require 'components/lib/slider-box'
# rateMap =
#     "0": "好评"
#     "1": "中评"
#     "2": "差评"

GalleryItem = React.createClass
    getInitialState: ->
        loaded: no
    onLoad: (e) ->
        @setState loaded: yes
    render: ->
        if @state.loaded
            <Img src={@props.data} w={window.innerWidth}/>
        else
            <div className="loading-placeholder">
                <Loading inside/>
                <Img src={@props.data} onLoad={@onLoad} w={window.innerWidth}/>
            </div>

PageView = React.createClass
    mixins: [liteFlux.mixins.storeMixin('comment')]
    getInitialState: ->
        show: no
        index: 0

    renderModal: (data) ->
        <Modal name="comment-gallery" onCloseClick={@onModalHide} show={@state.show} full-screen margin={0}>
            <Tappable onTap={@onModalHide} moveThreshold={20} className="comment-gallery">
                <SliderBox data={data} component={GalleryItem} full-screen nav-center auto={no} preventDefault active={@state.index}/>
            </Tappable>
        </Modal>
    onModalHide: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
        @setState show: no

    tap: (i, e) ->
        e.preventDefault()
        e.stopPropagation()
        @setState
            show: yes
            index: i

    renderLv: (data) ->
        switch data.rate
            when 0
                <span className="u-fr u-color-green">好评</span>
            when 1
                <span className="u-fr">中评</span>
            when 2
                <span className="u-fr u-color-red">差评</span>

    renderAlbum:(data) ->
        if data.pics.length
            pics = data.pics.map (item, i) =>
                <Tappable component="div" onTap={@tap.bind(null, i)} className="comment-item-img-box" key={i}>
                    <Img src={item} w={100}/>
                </Tappable>

            <div className="comment-item-album">
                {pics}
                {@renderModal(data.pics)}
            </div>

    render: ->
        data = @props.data
        <div className="comment-item">
            <div className="comment-item-hd">
                <span className="u-color-gray-summary">{data.member_name}</span>
                {@renderLv(data)}
            </div>
            <div className="comment-item-bd">
                {data.content}
            </div>
            {@renderAlbum(data)}
        </div>



module.exports = PageView
