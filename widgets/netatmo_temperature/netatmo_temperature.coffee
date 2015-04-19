class Dashing.NetatmoTemperature extends Dashing.Widget
    ready: ->
        @set('min_temp_time', '--')
        @set('max_temp_time', '--')

        @set('temperature_arrow', 'icon-arrow-right')

    onData: (data) ->
        @set('min_temp_time', @getTimeString(data.current.date_min_temp))
        @set('max_temp_time', @getTimeString(data.current.date_max_temp))

        # only set arrows when the value changes, keep previous state on equal
        if @get('previous.Temperature')
            if parseFloat(@get('current.Temperature')) > parseFloat(@get('previous.Temperature')) then @set('temperature_arrow', 'icon-arrow-up')
            if parseFloat(@get('current.Temperature')) < parseFloat(@get('previous.Temperature')) then @set('temperature_arrow', 'icon-arrow-down')

    getTimeString: (time) ->
        d = new Date(time*1000)

        h = d.getHours()
        m = d.getMinutes()

        m = @formatTime(m)

        return h + ":" + m

    formatTime: (i) ->
        if i < 10 then "0" + i else i
