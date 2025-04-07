class AddTimezoneToAirports < ActiveRecord::Migration[8.0]
  def change
    add_column :airports, :timezone, :string
  end
end
