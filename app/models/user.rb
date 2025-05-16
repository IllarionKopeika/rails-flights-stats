class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :flights, dependent: :destroy
  has_many :visits, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: { message: :blank_email_address }, uniqueness: { message: :taken_email_address }
  validates :password, presence: true

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  generates_token_for :email_confirmation, expires_in: 24.hours do
    email_address
  end
end
