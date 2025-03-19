class Country < ApplicationRecord
  belongs_to :subregion
  has_many :airports
end
