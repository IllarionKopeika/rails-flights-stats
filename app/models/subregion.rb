class Subregion < ApplicationRecord
  belongs_to :region
  has_many :countries
end
