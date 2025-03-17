class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: { message: :blank_email_address }, uniqueness: { message: :taken_email_address }
  validates :password, presence: true
end
