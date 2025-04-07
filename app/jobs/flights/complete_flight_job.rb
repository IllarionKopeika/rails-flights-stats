class Flights::CompleteFlightJob < ApplicationJob
  queue_as :default

  def perform(flight_id)
    flight = Flight.find_by(id: flight_id)
    return unless flight
    return if flight.completed?

    tz = flight.arrival_airport&.time_zone || 'UTC'
    arrival_datetime_local = Time.find_zone(tz).parse("#{flight.arrival_date} #{flight.arrival_time}")
    arrival_datetime_utc = arrival_datetime_local.utc

    return if Time.current < arrival_datetime_utc

    flight.update!(status: :completed)
  end
end
