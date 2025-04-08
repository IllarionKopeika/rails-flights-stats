class Flights::CompleteFlightJob < ApplicationJob
  queue_as :default

  def perform(flight_id)
    flight = Flight.find_by(id: flight_id)
    return unless flight
    return unless flight.upcoming?

    flight.update!(status: :completed)
    Rails.logger.debug ">>> from #{flight.departure_airport} to #{flight.arrival_airport} marked as completed by CompleteFlightJob"
  end
end
