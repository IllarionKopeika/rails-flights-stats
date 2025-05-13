class Flight < ApplicationRecord
  scope :upcoming, -> { where(status: :upcoming) }
  scope :completed, -> { where(status: :completed) }

  belongs_to :airline, optional: true
  belongs_to :aircraft, optional: true
  belongs_to :user

  belongs_to :departure_airport, class_name: 'Airport', foreign_key: 'departure_airport_id'
  belongs_to :arrival_airport, class_name: 'Airport', foreign_key: 'arrival_airport_id'

  enum :status, { upcoming: 0, completed: 1 }

  validates :number, presence: true
  validates :departure_date, presence: true
  validates :number, uniqueness: { scope: :departure_date, message: :duplicate_flight }

  def from_coordinates
    [departure_airport.latitude, departure_airport.longitude] if departure_airport
  end

  def to_coordinates
    [arrival_airport.latitude, arrival_airport.longitude] if arrival_airport
  end
end
