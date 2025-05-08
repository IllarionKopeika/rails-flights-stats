class Flights::UpdateCompletedFlightJob < ApplicationJob
  queue_as :default

  def perform(flight_id)
    flight = Flight.find_by(id: flight_id)
    return unless flight

    [flight.departure_airport, flight.arrival_airport].each do |airport|
      country = airport.country
      country.update!(visited: true) unless country.visited?
      region = country.subregion.region
      region.update!(visited: true) unless region.visited?
    end

    Flights::UpdateFlightAfterArrivalJob.perform_now(flight.id)
  end
end
