class Flights::CompleteFlightJob < ApplicationJob
  queue_as :default

  def perform(flight_id)
    flight = Flight.find_by(id: flight_id)
    return unless flight&.upcoming?

    flight.update!(status: :completed)

    user = flight.user

    country = flight.arrival_airport.country
    subregion = country.subregion
    region = subregion.region

    aircraft = flight.aircraft
    airline = flight.airline

    departure_airport = flight.departure_airport
    arrival_airport = flight.arrival_airport

    [country, subregion, region].each do |visitable|
      visit = Visit.find_or_initialize_by(user: user, visitable: visitable)
      visit.count += 1
      visit.save!
    end

    [aircraft, airline].each do |flightstatable|
      flight_stat = FlightStat.find_or_initialize_by(user: user, flightstatable: flightstatable)
      flight_stat.count += 1
      flight_stat.save!
    end

    [departure_airport, arrival_airport].uniq.each do |airport|
      stat = FlightStat.find_or_initialize_by(user: user, flightstatable: airport, role: :general)
      stat.count += 1
      stat.save!
    end

    {departure_airport => :departure, arrival_airport => :arrival}.each do |airport, role|
      airport_stat = FlightStat.find_or_initialize_by(user: user, flightstatable: airport, role: role)
      airport_stat.count += 1
      airport_stat.save!
    end
  end
end
