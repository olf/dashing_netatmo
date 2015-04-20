class Dashing.NetatmoNumber extends Dashing.Widget
    ready: ->
        @set('arrow', 'icon-chevron-right')

    onData: (data) ->
        # only set arrows when the value changes, keep previous state on equal
        if @get('previous')
            if parseFloat(@get('current')) > parseFloat(@get('previous')) then @set('arrow', 'icon-chevron-up')
            if parseFloat(@get('current')) < parseFloat(@get('previous')) then @set('arrow', 'icon-chevron-down')
