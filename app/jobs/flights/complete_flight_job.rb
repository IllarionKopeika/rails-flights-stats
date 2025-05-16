class Flights::CompleteFlightJob < ApplicationJob
  queue_as :default

  def perform(flight_id)
    flight = Flight.find_by(id: flight_id)
    return unless flight
    return unless flight.upcoming?

    flight.update!(status: :completed)
  end
end
