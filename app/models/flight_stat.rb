class FlightStat < ApplicationRecord
  belongs_to :user
  belongs_to :flightstatable, polymorphic: true

  enum :role, { general: 0, departure: 1, arrival: 2 }

  validates :count, numericality: { greater_than_or_equal_to: 0 }
  validates :role, presence: true, if: -> { flightstatable_type == 'Airport' }
end
