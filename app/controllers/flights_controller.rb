class FlightsController < ApplicationController
  require 'date'

  def index
    @flights = Flight.all
  end

  def create
    @flight = Flight.new(flight_params)
    @flight.user = Current.user

    if @flight.save
      flash[:success] = t('.create_success')
      redirect_to flights_path
    else
      render 'search', status: :unprocessable_entity
    end
  end

  def search; end

  def fetch
    carrier = params[:carrier]
    flight_number = params[:flight_number]
    date = format_date(params[:date])

    @flight_data = FlightFetcher.new(carrier, flight_number, date).call

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
    date.match?(/[а-яА-Я]/) ? date.gsub(/(Янв|Фев|Мар|Апр|Май|Июн|Июл|Авг|Сен|Окт|Ноя|Дек)/, months) : date
  end

  def flight_params
    params.require(:flight).permit(:number, :departure_date, :departure_time, :arrival_date, :arrival_time, :duration, :distance, :status, :airline_id, :aircraft_id, :departure_airport_id, :arrival_airport_id)
  end
end
