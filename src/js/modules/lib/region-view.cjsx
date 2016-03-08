###
# RegionView.
# @author remiel.
# @module region
###
RegionStore = require 'stores/region'
RegionAction = RegionStore.getAction()
T = React.PropTypes

RegionView = React.createClass
    mixins: [liteFlux.mixins.storeMixin('region')]

    getInitialState: ->
        showRegion: no

    onShowRegion: (e) ->
        if e
            e.preventDefault()
            e.stopPropagation()
            e.target.blur()
        @setState
            showRegion: yes

    onHideRegion: () ->
        @setState
            showRegion: no

    callback: (value) ->
        # console.log value
        if typeof @props.callback is 'function'
            @props.callback value


    render: ->
        # console.log 'render', @state
        region = @state.region

        <Tappable component="div" {...@props} onTap={@onShowRegion}>
            <span>{ region.province_name }</span>
            <span>{ region.city_name }</span>
            <span>{ region.district_name }</span>
            <RegionPicker callback={@callback} show={@state.showRegion} hide={@onHideRegion}></RegionPicker>
        </Tappable>

module.exports = RegionView
