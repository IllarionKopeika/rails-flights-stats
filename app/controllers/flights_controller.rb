class FlightsController < ApplicationController
  def index
    @upcoming_flights = Current.user.flights.upcoming.order(departure_date: :asc, departure_time: :asc)
    @completed_flights = Current.user.flights.completed.order(departure_date: :desc, departure_time: :desc)
  end

  def create
    @flight = Flight.new(flight_params)
    @flight.user = Current.user

    if params[:flight][:departure_date_utc].present? && params[:flight][:departure_time_utc].present?
      departure_utc = Time.zone.parse("#{params[:flight][:departure_date_utc]} #{params[:flight][:departure_time_utc]}").utc
      @flight.status = departure_utc > Time.current.utc ? :upcoming : :completed
    else
      @flight.status = :upcoming
    end

    @flight.departure_airport = Airport.find_or_create_by(code: params[:flight][:departure_airport_code]) do |airport|
      airport.country = Country.find_by(code: params[:flight][:departure_country_code])
    end
    @flight.arrival_airport = Airport.find_or_create_by(code: params[:flight][:arrival_airport_code]) do |airport|
      airport.country = Country.find_by(code: params[:flight][:arrival_country_code])
    end
    @flight.airline = Airline.find_or_create_by(code: params[:flight][:airline_code])
    @flight.aircraft = Aircraft.find_or_create_by(name: params[:flight][:aircraft])

    if @flight.save
      if @flight.upcoming?
        Flights::ScheduleCompletionJob.set(wait: 1.minute).perform_later(@flight.id)
      elsif @flight.completed?
        Flights::TrackVisitJob.set(wait: 1.minute).perform_later(@flight.id)
        Flights::TrackFlightStatsJob.set(wait: 1.minute).perform_later(@flight.id)
        Flights::CalculateGeneralStatJob.set(wait: 1.minute).perform_later(@flight.id)
      end

      flash[:success] = t('.create_success')
      redirect_to flights_path
    else
      # Rails.logger.debug ">>> errors #{@flight.errors.full_messages}"
      flash[:danger] = @flight.errors[:number].first
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

  def map
    @completed_flights = Current.user.flights.completed.includes(:departure_airport, :arrival_airport)

    @flights = @completed_flights.map do |flight|
      {
        from_coordinates: flight.from_coordinates,
        to_coordinates: flight.to_coordinates
      }
    end

    airports = @completed_flights.flat_map { |flight| [ flight.departure_airport, flight.arrival_airport ] }.uniq
    @markers = airports.map do |airport|
      {
        lat: airport.latitude,
        lng: airport.longitude,
        popup_html: render_to_string(partial: 'popup', locals: { airport: airport }),
        marker_html: render_to_string(partial: 'marker')
      }
    end
  end

  private

  def flight_status_param
    params[:status] == 'completed' ? :completed : :upcoming
  end

  def flight_params
    params.require(:flight).permit(:number, :departure_date, :departure_time, :arrival_date, :arrival_time, :duration, :distance)
  end

  def format_date(date)
    months = {
      'Jan' => '01', 'Feb' => '02', 'Mar' => '03', 'Apr' => '04',
      'May' => '05', 'Jun' => '06', 'Jul' => '07', 'Aug' => '08',
      'Sep' => '09', 'Oct' => '10', 'Nov' => '11', 'Dec' => '12',
      'Янв' => '01', 'Фев' => '02', 'Март' => '03', 'Апр' => '04',
      'Май' => '05', 'Июнь' => '06', 'Июль' => '07', 'Авг' => '08',
      'Сен' => '09', 'Окт' => '10', 'Ноя' => '11', 'Дек' => '12'
    }

    if date =~ /\A(\d{2})-([A-Za-zА-Яа-я]+)-(\d{4})\z/
      day, month_str, year = $1, $2, $3
      month = months[month_str]
      return "#{year}-#{month}-#{day}" if month
    end

    date
  end
end
