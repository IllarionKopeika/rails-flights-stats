class FlightsController < ApplicationController
  require 'httparty'

  def search
    carrier = params[:carrier]
    flight_number = params[:flight_number]
    date = params[:date]

    @flight_data = fetch_flight_data(carrier, flight_number, date)

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  private

  def fetch_flight_data(carrier, flight_number, date)
    url = 'https://flight-info-api.p.rapidapi.com/status'
    headers = {
      'x-rapidapi-key' => ENV['X_RAPIDAPI_KEY'],
      'x-rapidapi-host' => ENV['X_RAPIDAPI_HOST']
    }
    params = {
      version: 'v2',
      codeType: 'IATA',
      carrierCode: carrier,
      flightNumber: flight_number,
      departureDatetime: date
    }

    response = HTTParty.get(url, headers: headers, query: params)

    if response.success?
      flight_data = JSON.parse(response.body, symbolize_names: true)

      if flight_data[:data] && flight_data[:data][0]
        {
          flight_number: "#{flight_data[:data][0][:carrier][:iata]} #{flight_data[:data][0][:flightNumber]}",
          departure_country_code: flight_data[:data][0][:departure][:country][:code],
          departure_airport: flight_data[:data][0][:departure][:airport][:iata],
          departure_date: flight_data[:data][0][:departure][:date][:local],
          departure_time: flight_data[:data][0][:departure][:time][:local],
          arrival_country_code: flight_data[:data][0][:arrival][:country][:code],
          arrival_airport: flight_data[:data][0][:arrival][:airport][:iata],
          arrival_time: flight_data[:data][0][:arrival][:time][:local],
          duration: flight_data[:data][0][:elapsedTime]
        }
      else
        {
          flight_number: "#{carrier} #{flight_number}",
          departure_country_code: 'N/A',
          departure_airport: 'N/A',
          departure_date: 'N/A',
          departure_time: 'N/A',
          arrival_country_code: 'N/A',
          arrival_airport: 'N/A',
          arrival_time: 'N/A',
          duration: 'N/A'
        }
      end
    else
      {
        flight_number: "#{carrier} #{flight_number}",
        departure_country_code: 'N/A',
        departure_airport: 'N/A',
        departure_date: 'N/A',
        departure_time: 'N/A',
        arrival_country_code: 'N/A',
        arrival_airport: 'N/A',
        arrival_time: 'N/A',
        duration: 'N/A',
        status: "Error: #{response.code} - #{response.message}"
      }
    end
  rescue StandardError => e
    {
      flight_number: "#{carrier} #{flight_number}",
      departure_country_code: 'N/A',
      departure_airport: 'N/A',
      departure_date: 'N/A',
      departure_time: 'N/A',
      arrival_country_code: 'N/A',
      arrival_airport: 'N/A',
      arrival_time: 'N/A',
      duration: 'N/A',
      status: "Error: #{e.message}"
    }
  end
end
