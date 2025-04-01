class Flight < ApplicationRecord
  belongs_to :airline, optional: true
  belongs_to :aircraft, optional: true
  belongs_to :user

  belongs_to :departure_airport, class_name: 'Airport', foreign_key: 'departure_airport_id'
  belongs_to :arrival_airport, class_name: 'Airport', foreign_key: 'arrival_airport_id'

  enum :status, { upcoming: 0, completed: 1 }
end
