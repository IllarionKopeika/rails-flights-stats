class FlightFetcher
  require 'httparty'

  API_URL = 'https://flight-info-api.p.rapidapi.com/status'.freeze

  def initialize(carrier, flight_number, date)
    @carrier = carrier
    @flight_number = flight_number
    @date = date
  end

  def call
    response = HTTParty.get(API_URL, headers: headers, query: query_params)

    if response.success?
      parse_response(response)
    else
      { message: I18n.t('flight_not_found') }
    end
  rescue StandardError => e
    Rails.logger.error("Flight fetch error: #{e.message}")
    { message: I18n.t('flight_not_found') }
  end

  private

  def headers
    {
      'x-rapidapi-key' => ENV['X_RAPIDAPI_KEY'],
      'x-rapidapi-host' => ENV['X_RAPIDAPI_HOST']
    }
  end

  def query_params
    {
      version: 'v2',
      codeType: 'IATA',
      carrierCode: @carrier,
      flightNumber: @flight_number,
      departureDatetime: @date
    }
  end

  def parse_response(response)
    flight_data = JSON.parse(response.body, symbolize_names: true)

    if flight_data.dig(:data).blank?
      { message: I18n.t('flight_not_found') }
    else
      flight = flight_data[:data][0]

      {
        flight_number: "#{flight.dig(:carrier, :iata)} #{flight[:flightNumber]}",
        departure_country_code: flight.dig(:departure, :country, :code),
        departure_airport: flight.dig(:departure, :airport, :iata),
        departure_date: flight.dig(:departure, :date, :local),
        departure_date_utc: flight.dig(:departure, :date, :utc),
        departure_time: flight.dig(:departure, :time, :local),
        departure_time_utc: flight.dig(:departure, :time, :utc),
        arrival_country_code: flight.dig(:arrival, :country, :code),
        arrival_airport: flight.dig(:arrival, :airport, :iata),
        arrival_date: flight.dig(:arrival, :date, :local),
        arrival_date_utc: flight.dig(:arrival, :date, :utc),
        arrival_time: flight.dig(:arrival, :time, :local),
        arrival_time_utc: flight.dig(:arrival, :time, :utc),
        duration: flight[:elapsedTime],
        distance: flight.dig(:distance, :accumulatedGreatCircleKilometers),
        aircraft_code: flight.dig(:aircraftType, :iata)
      }
    end
  end
end
