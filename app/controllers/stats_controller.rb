class StatsController < ApplicationController
  def show
    @airports = Current.user.flight_stats.where(flightstatable_type: "Airport", role: "general").map do |stat|
      airport = Airport.find(stat.flightstatable_id)
      [ airport.name, airport.country.code, stat.count ]
    end
  end
end
