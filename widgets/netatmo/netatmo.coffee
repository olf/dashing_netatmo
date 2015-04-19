class Dashing.Netatmo extends Dashing.Widget
    ready: ->
        @set('outdoor_min_temp_time', '--')
        @set('outdoor_max_temp_time', '--')

        @set('indoor_min_temp_time', '--')
        @set('indoor_max_temp_time', '--')

        @set('co2_arrow', 'icon-arrow-right')
        @set('outdoor_temperature_arrow', 'icon-arrow-right')
        @set('indoor_temperature_arrow', 'icon-arrow-right')

    onData: (data) ->
        @set('outdoor_min_temp_time', @getTimeString(data.outdoor.date_min_temp))
        @set('outdoor_max_temp_time', @getTimeString(data.outdoor.date_max_temp))

        @set('indoor_min_temp_time', @getTimeString(data.indoor.date_min_temp))
        @set('indoor_max_temp_time', @getTimeString(data.indoor.date_max_temp))

        # only set arrows when the value changes, keep previous state on equal
        if @get('previous_indoor.CO2')
            if parseInt(@get('indoor.CO2')) > parseInt(@get('previous_indoor.CO2')) then @set('co2_arrow', 'icon-arrow-up')
            if parseInt(@get('indoor.CO2')) < parseInt(@get('previous_indoor.CO2')) then @set('co2_arrow', 'icon-arrow-down')

        if @get('previous_outdoor.Temperature')
            if parseInt(@get('outdoor.Temperature')) > parseInt(@get('previous_outdoor.Temperature')) then @set('outdoor_temperature_arrow', 'icon-arrow-up')
            if parseInt(@get('outdoor.Temperature')) < parseInt(@get('previous_outdoor.Temperature')) then @set('outdoor_temperature_arrow', 'icon-arrow-down')

        if @get('previous_indoor.Temperature')
            if parseInt(@get('indoor.Temperature')) > parseInt(@get('previous_indoor.Temperature')) then @set('indoor_temperature_arrow', 'icon-arrow-up')
            if parseInt(@get('indoor.Temperature')) < parseInt(@get('previous_indoor.Temperature')) then @set('indoor_temperature_arrow', 'icon-arrow-down')

    getTimeString: (time) ->
        d = new Date(time*1000)

        h = d.getHours()
        m = d.getMinutes()

        m = @formatTime(m)

        return h + ":" + m

    formatTime: (i) ->
        if i < 10 then "0" + i else i
