class Airline < ApplicationRecord
  has_many :flights

  after_create_commit :fetch_airline_data

  private

  def fetch_airline_data
    FetchAirlineDataJob.perform_later(self.id)
  end
end
