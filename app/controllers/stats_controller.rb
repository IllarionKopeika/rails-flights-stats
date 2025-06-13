class StatsController < ApplicationController
  def show
    # flights
    @flights = Current.user.flights

    # distance
    @total_distance = Current.user.flights.where(status: :completed).sum(:distance).round(1)
    @longest_flight_km = Current.user.flights.where(status: :completed).order(distance: :desc).first
    @shortest_flight_km = Current.user.flights.where(status: :completed).order(distance: :asc).first
    @average_distance = Current.user.flights.where(status: :completed).average(:distance).to_f.round(1)

    # duration
    @total_duration = Current.user.flights.where(status: :completed).sum(:duration)
    @longest_flight_min = Current.user.flights.where(status: :completed).order(duration: :desc).first
    @shortest_flight_min = Current.user.flights.where(status: :completed).order(duration: :asc).first
    @average_duration = Current.user.flights.where(status: :completed).average(:duration).to_i

    # all airports
    @airports = Current.user.flight_stats
      .where(flightstatable_type: 'Airport', role: 'general')
      .map do |stat|
        airport = Airport.find(stat.flightstatable_id)
        [ airport.code, airport.name, stat.count ]
      end
      .sort_by { |_, name, count| [ -count, name.downcase ] }

    # departure airports
    @departure_airports = Current.user.flight_stats
      .where(flightstatable_type: 'Airport', role: 'departure')
      .map do |stat|
        departure_airport = Airport.find(stat.flightstatable_id)
        [ departure_airport.code, departure_airport.name, stat.count ]
      end
      .sort_by { |_, name, count| [ -count, name.downcase ] }

    # arrival airports
    @arrival_airports = Current.user.flight_stats
      .where(flightstatable_type: 'Airport', role: 'arrival')
      .map do |stat|
        arrival_airport = Airport.find(stat.flightstatable_id)
        [ arrival_airport.code, arrival_airport.name, stat.count ]
      end
      .sort_by { |_, name, count| [ -count, name.downcase ] }

    # airlines
    @airlines = Current.user.flight_stats
      .where(flightstatable_type: 'Airline')
      .map do |stat|
        airline = Airline.find(stat.flightstatable_id)
        [ airline.logo_url, airline.code, airline.name, stat.count ]
      end
      .sort_by { |_, _, name, count| [ -count, name.downcase ] }

    # aircrafts
    @aircrafts = Current.user.flight_stats
      .where(flightstatable_type: 'Aircraft')
      .map do |stat|
        aircraft = Aircraft.find(stat.flightstatable_id)
        [ aircraft.name, stat.count ]
      end
      .sort_by { |name, count| [ -count, name.downcase ] }

    # countries
    @countries = Current.user.visits
      .where(visitable_type: 'Country')
      .map do |visit|
        country = Country.find(visit.visitable_id)
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
    Rails.logger.debug "REGIONS >>> #{@regions}"
  end
end
