class Aircraft < ApplicationRecord
  has_many :flights

  before_save :set_manufacturer

  private

  def set_manufacturer
    self.manufacturer = name.split.first if name.present?
  end
end
