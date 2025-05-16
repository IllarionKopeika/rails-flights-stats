class Flights::TrackVisitJob < ApplicationJob
  queue_as :default

  def perform(flight_id)
    flight = Flight.find_by(id: flight_id)
    return unless flight&.completed? && flight.user.present?

    user = flight.user
    country = flight.arrival_airport.country
    subregion = country.subregion
    region = subregion.region

    [country, subregion, region].each do |visitable|
      visit = Visit.find_or_initialize_by(user: user, visitable: visitable)
      visit.count += 1
      visit.save!
    end
  end
end
