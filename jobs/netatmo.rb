require 'curb'
require 'json'
require 'yaml'

def get_dashboard_data(nodes, node_name, name)
    data = nil

    nodes.each { |node|
        if node[node_name] == name then
            data = node['dashboard_data']
            break
        end
    }

    return data
end

indoor_data = nil
outdoor_data = nil

previous_indoor_data = nil
previous_outdoor_data = nil

config = YAML.load_file("config/netatmo.yml")

parameters = [
    Curl::PostField.content('grant_type', 'password'),
    Curl::PostField.content('client_id', config['app_id']),
    Curl::PostField.content('client_secret', config['app_secret']),
    Curl::PostField.content('username', config['username']),
    Curl::PostField.content('password', config['password']),
    Curl::PostField.content('scope', 'read_station')
]

interval = config['interval']

SCHEDULER.every interval, :first_in => 0 do
    c = Curl::Easy.http_post("https://api.netatmo.net/oauth2/token", *parameters) do |curl|
        curl.headers["Content-Type"] = 'application/x-www-form-urlencoded;charset=UTF-8'
    end

    if c.response_code != 200
        puts "Netatmo Auth Response: #{c.response_code}"
    else
        json = JSON.parse(c.body_str)
        token = json['access_token']

        answer = JSON.parse(Curl.get("https://api.netatmo.net/api/devicelist?access_token=#{token}").body_str)

        if answer.include? 'status'
            previous_indoor_data  = indoor_data
            previous_outdoor_data = outdoor_data

            indoor_data  = get_dashboard_data(answer['body']['devices'], 'station_name', config['indoor_name'])
            outdoor_data = get_dashboard_data(answer['body']['modules'], 'module_name', config['outdoor_name'])

            if previous_outdoor_data != nil && previous_indoor_data != nil
                send_event('netatmo_indoor',  current: indoor_data,  previous: previous_indoor_data)
                send_event('netatmo_outdoor', current: outdoor_data, previous: previous_outdoor_data)

                send_event('netatmo_outdoor_humidity', current: outdoor_data['Humidity'], previous: previous_outdoor_data['Humidity'])

                send_event('netatmo_indoor_co2',      current: indoor_data['CO2'],      previous: previous_indoor_data['CO2'])
                send_event('netatmo_indoor_noise',    current: indoor_data['Noise'],    previous: previous_indoor_data['Noise'])
                send_event('netatmo_indoor_humidity', current: indoor_data['Humidity'], previous: previous_indoor_data['Humidity'])
                send_event('netatmo_indoor_pressure', current: indoor_data['Pressure'], previous: previous_indoor_data['Pressure'])

                send_event('netatmo',
                  indoor:  indoor_data,
                  outdoor: outdoor_data,

                  previous_indoor: previous_indoor_data,
                  previous_outdoor: previous_outdoor_data
                )
            end
        else
            puts "#{Time.now} Netatmo error: #{answer['error']['message']} (#{answer['error']['code']})"
        end
    end
end
