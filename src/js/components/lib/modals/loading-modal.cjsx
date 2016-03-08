###
# loading-modal.
# @author remiel.
###
T = React.PropTypes

LoadingModal = React.createClass

    propTypes:
        show: T.bool

    getDefaultProps: ->
        show: no

    getInitialState: ->
        show: false

    componentDidMount: ->
        @setState
            show: @props.show

    componentWillReceiveProps: (nextProps) ->
        @setState
            show: nextProps.show

    onShow: () ->
        @setState
            show: true

    onHide: ->
        @setState
            show: false

    render: ->
        <Modal name="loading" onCloseClick={@onHide} show={@state.show} type="loading">
            {@props.children}
        </Modal>

module.exports = LoadingModal
