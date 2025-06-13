class StatsController < ApplicationController
  def show
    # flights
    @flights = Current.user.flights

    # distance
    completed_flights = Current.user.flights.where(status: :completed)
    @total_distance = completed_flights.sum(:distance).round(1)
    @longest_flight_km = completed_flights.order(distance: :desc).first
    @shortest_flight_km = completed_flights.order(distance: :asc).first
    @average_distance = completed_flights.average(:distance).to_f.round(1)

    # duration
    @total_duration = completed_flights.sum(:duration)
    @longest_flight_min = completed_flights.order(duration: :desc).first
    @shortest_flight_min = completed_flights.order(duration: :asc).first
    @average_duration = completed_flights.average(:duration).to_i

    # all airports
    airport_stats = Current.user.flight_stats.where(flightstatable_type: 'Airport', role: 'general')
    airports_by_id = Airport.where(id: airport_stats.map(&:flightstatable_id)).index_by(&:id)
    @airports = airport_stats.map do |stat|
      airport = airports_by_id[stat.flightstatable_id]
      [ airport.country.code, airport.code, airport.name, stat.count ]
    end.sort_by { |_, _, name, count| [ -count, name.downcase ] }

    # departure airports
    departure_airport_stats = Current.user.flight_stats.where(flightstatable_type: 'Airport', role: 'departure')
    departure_airports_by_id = Airport.where(id: departure_airport_stats.map(&:flightstatable_id)).index_by(&:id)
    @departure_airports = departure_airport_stats.map do |stat|
      departure_airport = departure_airports_by_id[stat.flightstatable_id]
      [ departure_airport.country.code, departure_airport.code, departure_airport.name, stat.count ]
    end.sort_by { |_, _, name, count| [ -count, name.downcase ] }

    # arrival airports
    arrival_airport_stats = Current.user.flight_stats.where(flightstatable_type: 'Airport', role: 'arrival')
    arrival_airports_by_id = Airport.where(id: arrival_airport_stats.map(&:flightstatable_id)).index_by(&:id)
    @arrival_airports = arrival_airport_stats.map do |stat|
      arrival_airport = arrival_airports_by_id[stat.flightstatable_id]
      [ arrival_airport.country.code, arrival_airport.code, arrival_airport.name, stat.count ]
    end.sort_by { |_, _, name, count| [ -count, name.downcase ] }

    # airlines
    airline_stats = Current.user.flight_stats.where(flightstatable_type: 'Airline')
    airlines_by_ids = Airline.where(id: airline_stats.map(&:flightstatable_id)).index_by(&:id)
    @airlines = airline_stats.map do |stat|
      airline = airlines_by_ids[stat.flightstatable_id]
      [ airline.logo_url, airline.code, airline.name, stat.count ]
    end.sort_by { |_, _, name, count| [ -count, name.downcase ] }

    # aircrafts
    aircraft_stats = Current.user.flight_stats.where(flightstatable_type: 'Aircraft')
    aircrafts_by_ids = Aircraft.where(id: aircraft_stats.map(&:flightstatable_id)).index_by(&:id)
    @aircrafts = aircraft_stats.map do |stat|
      aircraft = aircrafts_by_ids[stat.flightstatable_id]
      [ aircraft.name, stat.count ]
    end.sort_by { |name, count| [ -count, name.downcase ] }

    # countries
    country_stats = Current.user.visits.where(visitable_type: 'Country')
    country_by_ids = Country.where(id: country_stats.map(&:visitable_id)).index_by(&:id)
    @countries = country_stats.map do |visit|
      country = country_by_ids[visit.visitable_id]
      [ country.code, country.name ]
    end

    # continents & regions
    visited_country_ids = Current.user.visits
      .where(visitable_type: 'Country')
      .pluck(:visitable_id)
      .to_set
    @regions = Region.includes(subregions: :countries).map do |region|
      subregions_data = region.subregions.map do |subregion|
        total_countries = subregion.countries.count
        visited_countries = subregion.countries.where(id: visited_country_ids).count
        {
          name: subregion.name,
          total: total_countries,
          visited: visited_countries
        }
      end

      {
        name: region.name,
        visited: Current.user.visits.exists?(visitable: region),
        subregions: subregions_data
      }
    end
  end
end
