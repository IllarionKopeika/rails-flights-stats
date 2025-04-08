class Flights::ScheduleCompletionJob < ApplicationJob
  queue_as :default

  def perform(flight_id)
    flight = Flight.find_by(id: flight_id)
    return unless flight

    arrival_airport = flight.arrival_airport
    return unless arrival_airport && arrival_airport.timezone.present?
    return unless flight.arrival_date.present? && flight.arrival_time.present?

    local_time = Time.find_zone(arrival_airport.timezone).parse("#{flight.arrival_date} #{flight.arrival_time}")
    Rails.logger.debug ">>> local_time #{local_time}"
    return unless local_time

    Flights::CompleteFlightJob.set(wait_until: local_time.utc).perform_later(flight.id)
  end
end
