class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :visitable, polymorphic: true

  validates :count, numericality: { greater_than_or_equal_to: 0 }
end
