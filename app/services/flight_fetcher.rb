class FlightFetcher
  require 'httparty'

  def initialize(carrier, flight_number, date)
    @carrier = carrier
    @flight_number = flight_number
    @date = date
  end

  def call
    url = "https://aerodatabox.p.rapidapi.com/flights/number/#{@carrier}#{@flight_number}/#{@date}"
    Rails.logger.debug ">>> URL #{url}"
    response = HTTParty.get(url, headers: headers, query: query_params)
    Rails.logger.debug ">>> flight search res #{response}"

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
      withAircraftImage: 'false',
      withLocation: 'false',
      dateLocalRole: 'both'
    }
  end

  def parse_response(response)
    flight_data = JSON.parse(response.body, symbolize_names: true)

    if flight_data.empty?
      { message: I18n.t('flight_not_found') }
    else
      flight = flight_data[0]
      flight_number = flight.dig(:number)
      departure_local = flight.dig(:departure, :scheduledTime, :local)
      departure_utc = flight.dig(:departure, :scheduledTime, :utc)
      arrival_local = flight.dig(:arrival, :scheduledTime, :local)
      arrival_utc = flight.dig(:arrival, :scheduledTime, :utc)
      duration =
        if departure_utc && arrival_utc
          ((Time.parse(arrival_utc) - Time.parse(departure_utc)) / 60).to_i
        else
          nil
        end

      {
        flight_number: flight_number.delete(' '),
        departure_country_code: flight.dig(:departure, :airport, :countryCode),
        departure_airport: flight.dig(:departure, :airport, :iata),
        departure_date: departure_local.slice(0, 10),
        departure_date_utc: departure_utc.slice(0, 10),
        departure_time: departure_local.slice(11, 5),
        departure_time_utc: departure_utc.slice(11, 5),
        arrival_country_code: flight.dig(:arrival, :airport, :countryCode),
        arrival_airport: flight.dig(:arrival, :airport, :iata),
        arrival_date: arrival_local.slice(0, 10),
        arrival_date_utc: arrival_utc.slice(0, 10),
        arrival_time: arrival_local.slice(11, 5),
        arrival_time_utc: arrival_utc.slice(11, 5),
        duration: duration,
        distance: flight.dig(:greatCircleDistance, :km),
        aircraft: flight.dig(:aircraft, :model)
      }
    end
  end
end
