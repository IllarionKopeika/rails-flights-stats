class AddCoordinatesToAirport < ActiveRecord::Migration[8.0]
  def change
    add_column :airports, :latitude, :float
    add_column :airports, :longitude, :float
  end
end
