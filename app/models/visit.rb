class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :visitable, polymorphic: true

  validates :user_id, uniqueness: { scope: [:visitable_type, :visitable_id] }
end
