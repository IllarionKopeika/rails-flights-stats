class Flights::UpdateFlightAfterArrivalJob < ApplicationJob
  queue_as :default

  def perform(flight_id)
    flight = Flight.find_by(id: flight_id)
    return unless flight

    carrier, number = flight.number.split

    url = 'https://flight-info-api.p.rapidapi.com/status'
    headers = {
      'x-rapidapi-key' => ENV['X_RAPIDAPI_KEY'],
      'x-rapidapi-host' => ENV['X_RAPIDAPI_HOST']
    }
    query_params = {
      version: 'v2',
      codeType: 'IATA',
      carrierCode: carrier,
      flightNumber: number,
      departureDatetime: flight.departure_date
    }

    response = HTTParty.get(url, headers: headers, query: query_params)
    if response.success?
      data = JSON.parse(response.body, symbolize_names: true)
      if data.dig(:data).blank?
        reset_fields(flight)
      else
        updated_data = data[:data][0]
        if updated_data.dig(:statusDetails).blank?
          reset_fields(flight)
        else
          actual_data = updated_data[:statusDetails][0]
          flight.update!(
            actual_departure_date: parse_date(actual_data.dig(:departure, :actualTime, :outGate, :local)),
            actual_departure_time: parse_time(actual_data.dig(:departure, :actualTime, :outGate, :local)),
            departure_status: actual_data.dig(:departure, :actualTime, :outGateTimeliness),
            departure_timing: actual_data.dig(:departure, :actualTime, :outGateVariation),
            actual_arrival_date: parse_date(actual_data.dig(:arrival, :actualTime, :inGate, :local)),
            actual_arrival_time: parse_time(actual_data.dig(:arrival, :actualTime, :inGate, :local)),
            arrival_status: actual_data.dig(:arrival, :actualTime, :outGateTimeliness),
            arrival_timing: actual_data.dig(:arrival, :actualTime, :outGateVariation),
          )
        end
      end
    else
      reset_fields(flight)
    end
  end

  private

  def parse_date(date)
    Time.parse(date).strftime('%Y-%m-%d') if date.present?
  end

  def parse_time(time)
    Time.parse(time).strftime('%H:%M') if time.present?
  end

  def reset_fields(flight)
    flight.update!(
      actual_departure_date: nil,
      actual_departure_time: nil,
      departure_status: nil,
      departure_timing: nil,
      actual_arrival_date: nil,
      actual_arrival_time: nil,
      arrival_status: nil,
      arrival_timing: nil,
    )
  end
end
