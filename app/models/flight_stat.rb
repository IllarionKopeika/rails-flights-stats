class FlightStat < ApplicationRecord
  belongs_to :user
  belongs_to :flightstatable, polymorphic: true

  validates :count, numericality: { greater_than_or_equal_to: 0 }
end
