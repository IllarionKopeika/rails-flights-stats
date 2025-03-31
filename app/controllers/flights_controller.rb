class FlightsController < ApplicationController
  require 'httparty'
  require 'date'

  def search
    carrier = params[:carrier]
    flight_number = params[:flight_number]
    date = format_date(params[:date])

    @flight_data = fetch_flight_data(carrier, flight_number, date)

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  private

  def format_date(date)
    months = {
      'Янв' => 'Jan', 'Фев' => 'Feb', 'Мар' => 'Mar', 'Апр' => 'Apr',
      'Май' => 'May', 'Июн' => 'Jun', 'Июл' => 'Jul', 'Авг' => 'Aug',
      'Сен' => 'Sep', 'Окт' => 'Oct', 'Ноя' => 'Nov', 'Дек' => 'Dec'
    }
    if date.match?(/[а-яА-Я]/)
      date = date.gsub(/(Янв|Фев|Мар|Апр|Май|Июн|Июл|Авг|Сен|Окт|Ноя|Дек)/, months)
    else
      date
    end
  end

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
    Rails.logger.debug "Response: #{response}"

    if response.success?
      flight_data = JSON.parse(response.body, symbolize_names: true)

      if flight_data[:data] && flight_data[:data].empty?
        {
          message: t('flight_not_found')
        }
      elsif flight_data[:data] && flight_data[:data][0]
        {
          flight_number: "#{flight_data[:data][0][:carrier][:iata]} #{flight_data[:data][0][:flightNumber]}",
          departure_country_code: flight_data[:data][0][:departure][:country][:code],
          departure_airport: flight_data[:data][0][:departure][:airport][:iata],
          departure_date: flight_data[:data][0][:departure][:date][:local],
          departure_time: flight_data[:data][0][:departure][:time][:local],
          arrival_country_code: flight_data[:data][0][:arrival][:country][:code],
          arrival_airport: flight_data[:data][0][:arrival][:airport][:iata],
          arrival_date: flight_data[:data][0][:arrival][:date][:local],
          arrival_time: flight_data[:data][0][:arrival][:time][:local],
          duration: flight_data[:data][0][:elapsedTime]
        }
      end
    else
      {
        message: t('flight_not_found')
      }
    end
    rescue StandardError => e
      {
        message: t('flight_not_found')
      }
  end
end
