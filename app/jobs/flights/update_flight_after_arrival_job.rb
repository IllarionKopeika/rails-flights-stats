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
          Rails.logger.info "ACTUAL DATA: #{actual_data}"
          flight.update!(
            actual_departure_date: parse_date(actual_data.dig(:departure, :actualTime, :outGate, :local)),
            actual_departure_time: parse_time(actual_data.dig(:departure, :actualTime, :outGate, :local)),
            departure_status: parse_status(actual_data.dig(:departure, :actualTime, :outGateTimeliness)),
            departure_timing: parse_timing(actual_data.dig(:departure, :actualTime, :outGateVariation)),
            actual_arrival_date: parse_date(actual_data.dig(:arrival, :actualTime, :inGate, :local)),
            actual_arrival_time: parse_time(actual_data.dig(:arrival, :actualTime, :inGate, :local)),
            arrival_status: parse_status(actual_data.dig(:arrival, :actualTime, :inGateTimeliness)),
            arrival_timing: parse_timing(actual_data.dig(:arrival, :actualTime, :inGateVariation)),
          )
        end
      end
    else
      reset_fields(flight)
    end
  end

  private

  def parse_date(date)
    return '' if date.nil?
    parsed_date = Time.parse(date).strftime('%Y-%m-%d')
    Rails.logger.info "PARSED DATE: #{parsed_date}"
    parsed_date
  end

  def parse_time(time)
    return '' if time.nil?
    parsed_time = Time.parse(time).strftime('%H:%M')
    Rails.logger.info "PARSED TIME: #{parsed_time}"
    parsed_time
  end

  def parse_status(status)
    return '' if status.nil?
    parsed_status = status
    Rails.logger.info "PARSED STATUS: #{parsed_status}"
    parsed_status
  end

  def parse_timing(timing)
    return '' if timing.nil?
    hours, minutes, _seconds = timing.split(':').map(&:to_i)
    parsed_timing = hours * 60 + minutes
    Rails.logger.info "PARSED TIMING: #{parsed_timing}"
    parsed_timing
  end

  def reset_fields(flight)
    flight.update!(
      actual_departure_date: '',
      actual_departure_time: '',
      departure_status: '',
      departure_timing: '',
      actual_arrival_date: '',
      actual_arrival_time: '',
      arrival_status: '',
      arrival_timing: '',
    )
  end
end
