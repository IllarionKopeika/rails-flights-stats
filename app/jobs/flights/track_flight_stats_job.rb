class Flights::TrackFlightStatsJob < ApplicationJob
  queue_as :default

  def perform(flight_id)
    flight = Flight.find_by(id: flight_id)
    return unless flight&.completed? && flight.user.present?

    user = flight.user
    aircraft = flight.aircraft
    airline = flight.airline
    departure_airport = flight.departure_airport
    arrival_airport = flight.arrival_airport

    [aircraft, airline, departure_airport, arrival_airport].each do |flightstatable|
      flight_stat = FlightStat.find_or_initialize_by(user: user, flightstatable: flightstatable)
      flight_stat.count += 1
      flight_stat.save!
    end

    [departure_airport, arrival_airport].each do |airport|
      airport_stat = FlightStat.find_or_initialize_by(user: user, flightstatable: airport)
      airport_stat.count += 1
      airport_stat.save!
    end
  end
end
