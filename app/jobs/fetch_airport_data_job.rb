class FetchAirportDataJob < ApplicationJob
  require 'httparty'
  queue_as :default

  def perform(airport_id)
    airport = Airport.find_by(id: airport_id)
    return unless airport

    url = 'https://iata-code-decoder.p.rapidapi.com/airports'
    headers = {
      'x-rapidapi-key' => ENV['IATA_KEY'],
      'x-rapidapi-host' => ENV['IATA_HOST']
    }
    querystring = {
      query: airport.code
    }

    response = HTTParty.get(url, headers: headers, query: querystring)
    if response.success?
      data = JSON.parse(response.body, symbolize_names: true)
      Rails.logger.debug ">>> data #{data}"
      if data.dig(:data).blank?
        airport.update!(name: 'Unknown Airport')
      else
        airport_data = data[:data][0]
        airport.update!(name: airport_data[:name], timezone: airport_data[:timeZone])
      end
    else
      airport.update!(name: 'Unknown Airport')
    end
  end
end
