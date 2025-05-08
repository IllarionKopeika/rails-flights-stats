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
      Rails.logger.info "DATA: #{data}"
      if data.dig(:data).blank?
        reset_fields(airport)
      else
        airport_data = data[:data][0]
        airport.update!(
          name: airport_data.dig(:name),
          timezone: airport_data.dig(:timeZone)
        )
      end
    else
      reset_fields(airport)
    end
  end

  private

  def reset_fields(airport)
    airport.update!(name: 'Unknown Airport')
  end
end
