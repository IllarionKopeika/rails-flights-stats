class Aircraft < ApplicationRecord
  before_save :set_manufacturer

  private

  def set_manufacturer
    self.manufacturer = name.split.first if name.present?
  end
end
