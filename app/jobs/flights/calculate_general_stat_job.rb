class Flights::CalculateGeneralStatJob < ApplicationJob
  queue_as :default

  def perform(flight_id)
    flight = Flight.find_by(id: flight_id)
    return unless flight&.completed? && flight.user.present?

    general_stat = flight.user.general_stat
    return unless general_stat

    general_stat.update!(
      total_flights: general_stat.total_flights + 1,
      total_duration: general_stat.total_duration + flight.duration,
      total_distance: general_stat.total_distance + flight.distance
    )

    if flight.international?
      general_stat.increment!(:international_flights)
    else
      general_stat.increment!(:domestic_flights)
    end
  end
end
