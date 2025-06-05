class StatsController < ApplicationController
  def show
    @longest_flight_min = Current.user.flights.where(status: :completed).order(duration: :desc).first
    @shortest_flight_min = Current.user.flights.where(status: :completed).order(duration: :asc).first
    @longest_flight_km = Current.user.flights.where(status: :completed).order(distance: :desc).first
    @shortest_flight_km = Current.user.flights.where(status: :completed).order(distance: :asc).first

    @airports = Current.user.flight_stats
      .where(flightstatable_type: 'Airport', role: 'general')
      .map do |stat|
        airport = Airport.find(stat.flightstatable_id)
        [ airport.country.code, airport.code, airport.name, stat.count ]
      end
      .sort_by { |_, _, name, count| [ -count, name.downcase ] }

    @departure_airports = Current.user.flight_stats
      .where(flightstatable_type: 'Airport', role: 'departure')
      .map do |stat|
        departure_airport = Airport.find(stat.flightstatable_id)
        [ departure_airport.country.code, departure_airport.code, departure_airport.name, stat.count ]
      end
      .sort_by { |_, _, name, count| [ -count, name.downcase ] }

    @arrival_airports = Current.user.flight_stats
      .where(flightstatable_type: 'Airport', role: 'arrival')
      .map do |stat|
        arrival_airport = Airport.find(stat.flightstatable_id)
        [ arrival_airport.country.code, arrival_airport.code, arrival_airport.name, stat.count ]
      end
      .sort_by { |_, _, name, count| [ -count, name.downcase ] }

      @airlines = Current.user.flight_stats
        .where(flightstatable_type: 'Airline')
        .map do |stat|
          airline = Airline.find(stat.flightstatable_id)
          [ airline.logo_url, airline.code, airline.name, stat.count ]
        end
        .sort_by { |_, _, name, count| [ -count, name.downcase ] }

      @aircrafts = Current.user.flight_stats
        .where(flightstatable_type: 'Aircraft')
        .map do |stat|
          aircraft = Aircraft.find(stat.flightstatable_id)
          [ aircraft.code, aircraft.name, stat.count ]
        end
        .sort_by { |_, name, count| [ -count, name.downcase ] }
  end
end
