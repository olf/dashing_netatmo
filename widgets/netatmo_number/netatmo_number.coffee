class Dashing.NetatmoNumber extends Dashing.Widget
    ready: ->
        @set('arrow', 'icon-arrow-right')

    onData: (data) ->
        # only set arrows when the value changes, keep previous state on equal
        if @get('previous')
            if parseFloat(@get('current')) > parseFloat(@get('previous')) then @set('arrow', 'icon-arrow-up')
            if parseFloat(@get('current')) < parseFloat(@get('previous')) then @set('arrow', 'icon-arrow-down')
