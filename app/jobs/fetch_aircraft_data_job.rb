class FetchAircraftDataJob < ApplicationJob
  require 'httparty'
  queue_as :default

  def perform(aircraft_id)
    aircraft = Aircraft.find_by(id: aircraft_id)
    return unless aircraft

    url = 'https://iata-code-decoder.p.rapidapi.com/aircraft'
    headers = {
      'x-rapidapi-key' => ENV['IATA_KEY'],
      'x-rapidapi-host' => ENV['IATA_HOST']
    }
    querystring = {
      query: aircraft.code
    }

    response = HTTParty.get(url, headers: headers, query: querystring)
    if response.success?
      data = JSON.parse(response.body, symbolize_names: true)
      Rails.logger.info "DATA: #{data}"
      if data.dig(:data).blank?
        reset_fields(aircraft)
      else
        aircraft_data = data[:data][0]
        aircraft.update!(name: aircraft_data.dig(:name))
      end
    else
      reset_fields(aircraft)
    end
  end

  private

  def reset_fields(aircraft)
    aircraft.update!(name: 'Unknown Aircraft')
  end
end
