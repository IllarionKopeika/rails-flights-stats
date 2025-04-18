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
end
