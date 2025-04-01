class AddUniqueIndexToFlights < ActiveRecord::Migration[8.0]
  def change
    add_index :flights, [:number, :departure_date], unique: true
  end
end
