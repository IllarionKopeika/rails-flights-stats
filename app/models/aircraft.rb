class Aircraft < ApplicationRecord
  has_many :flights

  after_create_commit :fetch_aircraft_data
  before_save :set_manufacturer

  private

  def fetch_aircraft_data
    FetchAircraftDataJob.perform_later(self.id)
  end

  def set_manufacturer
    self.manufacturer = name.split.first if name.present?
  end
end
